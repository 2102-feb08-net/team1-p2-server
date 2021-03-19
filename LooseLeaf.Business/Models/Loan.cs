﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LooseLeaf.Business.Models
{
    public class Loan : ILoan
    {
        public int Lender { get; }

        public int Borrower { get; }

        public string Message { get; }

        public DateTimeOffset DropoffDate { get; }

        public DateTimeOffset ReturnDate { get; }

        public IAddress ExchangeLocation { get; }

        public List<IOwnedBook> LoanedBooks { get; }

        public LoanStatus Status { get; }

        public bool IsPublic { get; }

        public Loan(int lenderId, int borrowerId, string message, DateTimeOffset pickUpDate, DateTimeOffset returnDate, IAddress address, List<IOwnedBook> loanedBooks)
        {
            if (lenderId <= 0)
                throw new ArgumentException("The lenderId must be greater than 0.", nameof(lenderId));
            if (borrowerId <= 0)
                throw new ArgumentException("The borrowId must be greater than 0.", nameof(borrowerId));
            if (pickUpDate >= returnDate)
                throw new ArgumentException("The pickup date and time must be before the return date and time.");
            if (address is null)
                throw new ArgumentNullException(nameof(address));
            if (loanedBooks is null)
                throw new ArgumentNullException(nameof(loanedBooks));

            if (loanedBooks.Count == 0)
                throw new ArgumentException("The number of loan books must be at least 1.");

            if (loanedBooks.Find(b => b.OwnerId != lenderId) is not null)
                throw new ArgumentException("Every book loaned, must be owned by the lender.");

            Lender = lenderId;
            Borrower = borrowerId;
            Message = message;
            DropoffDate = pickUpDate;
            ReturnDate = returnDate;
            ExchangeLocation = address;
            LoanedBooks = loanedBooks;
            Status = LoanStatus.Requested;
            IsPublic = true;
        }
    }
}