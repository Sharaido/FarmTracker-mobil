using System;
using System.Collections.Generic;
using System.Text;

namespace Test.Models
{
    public class Entity
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public int Amount { get; set; }
        public string PurchaseDate { get; set; }
        public float Cost { get; set; }
        public bool Sold { get; set; }
        public string SoldDate { get; set; }
        public float SoldPrice { get; set; }
        public string Note { get; set; }
    }
}
