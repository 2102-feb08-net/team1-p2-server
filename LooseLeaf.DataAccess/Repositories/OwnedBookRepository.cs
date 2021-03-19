﻿using LooseLeaf.Business.IRepositories;
using LooseLeaf.Business.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using LooseLeaf.Business;

namespace LooseLeaf.DataAccess.Repositories
{
    public class OwnedBookRepository : IOwnedBookRepository
    {
        private readonly LooseLeafContext _context;

        public OwnedBookRepository(LooseLeafContext context)
        {
            _context = context;
        }

        public async Task AddOwnedBookAsync(IOwnedBook ownedBook)
        {
            var user = await _context.Users.SingleAsync(u => u.Id == ownedBook.OwnerId);
            var book = await _context.Books.SingleOrDefaultAsync(b => b.Isbn == ownedBook.Isbn.IsbnValue);
            if (book is null)
            {
                GoogleBooks googleBooks = new GoogleBooks();
                IBook bookObj = await googleBooks.GetBookFromIsbn(ownedBook.Isbn.IsbnValue);
                book = await AddBook(bookObj);
            }

            var ownedBookData = new OwnedBook()
            {
                User = user,
                Book = book,
                ConditionId = (int)ownedBook.Condition,
                AvailabilityStatusId = (int)ownedBook.Availability
            };

            await _context.OwnedBooks.AddAsync(ownedBookData);
        }

        public async Task UpdateOwnedBookStatus(int ownedBookId, Availability? availability, PhysicalCondition? condition)
        {
            var ownedBook = await _context.OwnedBooks.SingleAsync(b => b.Id == ownedBookId);
            if (availability.HasValue)
                ownedBook.AvailabilityStatusId = (int)availability;
            if (condition.HasValue)
                ownedBook.ConditionId = (int)condition;
        }

        private async Task<Book> AddBook(IBook book)
        {
            Book newBook = new Book()
            {
                Title = book.Title,
                Author = book.Author,
                Isbn = book.Isbn,
            };

            var genres = book.Genres.Select(g => new Genre()
            {
                GenreName = g,
                Book = newBook,
            });

            await _context.Genres.AddRangeAsync(genres);
            await _context.Books.AddAsync(newBook);
            return newBook;
        }

        public async Task SaveChangesAsync() => await _context.SaveChangesAsync();

        public async Task<IEnumerable<IOwnedBook>> GetOwnedBooksAsync(IOwnedBookSearchParams searchParams)
        {
            IQueryable<OwnedBook> ownedBooksQuery = _context.OwnedBooks.Include(o => o.Book).Include(o => o.User).ThenInclude(u => u.Address);

            if (searchParams.BookAvailability.HasValue)
                ownedBooksQuery = ownedBooksQuery.Where(o => o.AvailabilityStatusId == (int)searchParams.BookAvailability);
            if (searchParams.BookCondition.HasValue)
                ownedBooksQuery = ownedBooksQuery.Where(o => o.ConditionId == (int)searchParams.BookCondition);
            if (searchParams.UserId.HasValue)
                ownedBooksQuery = ownedBooksQuery.Where(o => o.UserId == searchParams.UserId);

            var ownedBooks = await ownedBooksQuery.ToListAsync();
            return ownedBooks.Select(o => new Business.Models.OwnedBook(
                o.Id,
                new IsbnData(o.Book.Isbn),
                o.UserId,
                (PhysicalCondition)o.ConditionId,
                (Availability)o.AvailabilityStatusId));
        }
    }
}