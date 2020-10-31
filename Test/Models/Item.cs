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
        public List<Entity> Entities { get; set; }
    }
}