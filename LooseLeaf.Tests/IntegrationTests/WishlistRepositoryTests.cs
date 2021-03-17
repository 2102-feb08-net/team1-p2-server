﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using Moq;
using LooseLeaf.DataAccess;
using LooseLeaf.Business.IRepositories;
using LooseLeaf.DataAccess.Repositories;
using LooseLeaf.Business.Models;
using Microsoft.EntityFrameworkCore;

namespace LooseLeaf.Tests.IntegrationTests
{
    public class WishlistRepositoryTests
    {
        [Fact]
        public async Task WishlistRepository_GetWishlist_ReturnList()
        {
            // arrange
            const string username = "user";
            Mock<IUser> fakeUser = new Mock<IUser>();
            fakeUser.Setup(u => u.UserName).Returns(username);
            using var contextFactory = new TestLooseLeafContextFactory();

            List<DataAccess.Wishlist> wishlists = new List<DataAccess.Wishlist>()
            {
                new DataAccess.Wishlist() { UserId = 1, BookId = 1 },
                new DataAccess.Wishlist() { UserId = 1, BookId = 2 },
                new DataAccess.Wishlist() { UserId = 1, BookId = 3 }
            };

            using (LooseLeafContext addContext = contextFactory.CreateContext())
            {
                await contextFactory.CreateUser(addContext, username);
                await addContext.Genres.AddAsync(new DataAccess.Genre() { GenreName = "Story" });
                await addContext.SaveChangesAsync();
                await addContext.Books.AddRangeAsync(new List<DataAccess.Book>{
                    new DataAccess.Book() { Title = "Book 1", Author = "Author 1", Isbn = 1234567890123, GenreId = 1},
                    new DataAccess.Book() { Title = "Book 2", Author = "Author 2", Isbn = 1235567890123, GenreId = 1},
                    new DataAccess.Book() { Title = "Book 3", Author = "Author 3", Isbn = 1234777890123, GenreId = 1}
                });
                await addContext.SaveChangesAsync();
                await addContext.Wishlists.AddRangeAsync(wishlists);
                await addContext.SaveChangesAsync();
            }

            using LooseLeafContext context = contextFactory.CreateContext();
            IWishlistRepository wishlistRepository = new WishlistRepository(context);

            // act
            var books = await wishlistRepository.GetUserWishlist(fakeUser.Object);

            // assert
            Assert.Equal(wishlists.Count, books.Count());
        }

        [Fact]
        public async Task WishlistRepository_AddBookToWishlist()
        {
            // arrange
            const string username = "user";
            const string bookName = "Test Book";
            const string authorName = "The Author";
            long isbn;

            using var contextFactory = new TestLooseLeafContextFactory();
            using (LooseLeafContext arrangeContext = contextFactory.CreateContext())
            {
                await contextFactory.CreateUser(arrangeContext, username);
                isbn = await contextFactory.CreateBook(arrangeContext, bookName, authorName);
            }

            Mock<IUser> fakeUser = new Mock<IUser>();
            fakeUser.Setup(u => u.UserName).Returns(username);

            Mock<IBook> fakeBook = new Mock<IBook>();
            fakeBook.Setup(b => b.Title).Returns(bookName);
            fakeBook.Setup(b => b.Author).Returns(authorName);
            fakeBook.Setup(b => b.Isbn).Returns(isbn);

            // act
            using (LooseLeafContext actContext = contextFactory.CreateContext())
            {
                IWishlistRepository wishlistRepository = new WishlistRepository(actContext);
                await wishlistRepository.AddBookToUserWishlist(fakeUser.Object, fakeBook.Object);
                await actContext.SaveChangesAsync();
            }

            // assert
            using (LooseLeafContext assertContext = contextFactory.CreateContext())
            {
                var wishlist = await assertContext.Wishlists.Include(w => w.User).Include(w => w.Book).SingleAsync();
                Assert.Equal(username, wishlist.User.Username);
                Assert.Equal(bookName, wishlist.Book.Title);
                Assert.Equal(authorName, wishlist.Book.Author);
            }
        }
    }
}