using System;
using System.Collections.Generic;

namespace Test.Models
{
    public class Item
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Image { get; set; }
        public string Address { get; set; }
        public int Size { get; set; }
        public bool IsFarm { get; set; }
        public List<Entity> Entities { get; set; }
    }
}