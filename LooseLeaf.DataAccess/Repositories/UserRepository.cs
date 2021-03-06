using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LooseLeaf.Business.IRepositories;
using LooseLeaf.Business.Models;
using Microsoft.EntityFrameworkCore;

namespace LooseLeaf.DataAccess.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly LooseLeafContext _context;

        public UserRepository(LooseLeafContext context)
        {
            _context = context;
        }

        public async Task<int> AddUserAsync(INewUser user)
        {
            var existingUser = await _context.Users.SingleOrDefaultAsync(u => u.AuthId == user.AuthId);

            if (existingUser is not null)
                return existingUser.Id;

            User newUser = new User()
            {
                Username = user.Username,
                AuthId = user.AuthId,
                Email = user.Email,
            };

            await _context.Users.AddAsync(newUser);
            await _context.SaveChangesAsync();

            return newUser.Id;
        }

        public async Task<IEnumerable<IUser>> GetAllUsersAsync()
        {
            var userList = await _context.Users.Select(u =>
            new Business.Models.User(
                    u.Id,
                    u.Username,
                    u.Email
                )).ToListAsync();
            return userList;
        }

        public async Task<IEnumerable<IBook>> GetRecommendedBooksAsync(int userId)
        {
            var loans = _context.Loans.Where(b => b.BorrowerId == userId)
            .Include(b => b.LoanedBooks).ThenInclude(b => b.OwnedBook)
            .ThenInclude(b => b.Book).ThenInclude(b => b.Genres);
            var loanbooks = loans.Select(b => b.LoanedBooks).SelectMany(g => g);
            var ownedbooks = loanbooks.Select(b => b.OwnedBook);
            var booklist = await ownedbooks.Select(b => b.Book).ToListAsync();
            var _genre = booklist.Select(b => b.Genres).SelectMany(b => b);

            if (!loans.Any())
            {
                return await _context.Books.Include(b => b.Genres).Select(b => b.ConvertToIBook()).Take(5).ToListAsync();
            }
            else
            {
                var grouped = _genre.GroupBy(item => item);
                var items = grouped.SelectMany(g => g);
                string name = items.First().GenreName;
                var genre = await _context.Genres.Where(g => g.GenreName.Equals(name)).FirstOrDefaultAsync();

                return _context.Books.Include(b => b.Genres).Where(g => g.Genres.Contains(genre)).Select(b => b.ConvertToIBook()).Take(5).ToList();
            }

            //checks to see if the list is empty. if it is empty, grab the first five books in the database and suggest them.
        }

        public async Task<IUser> GetUserAsync(int userId)
        {
            var user = await _context.Users.Where(b => b.Id == userId).SingleAsync();
            return new Business.Models.User(userId, user.Username, user.Email);
        }

        public async Task<bool> DoesIdHaveAuthIdAddressAsync(int userId, string authId)
        {
            var user = await _context.Users.SingleAsync(user => user.Id == userId);
            return user.AuthId == authId;
        }

        public async Task SaveChangesAsync() => await _context.SaveChangesAsync();
    }
}