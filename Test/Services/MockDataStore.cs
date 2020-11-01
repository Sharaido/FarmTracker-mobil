﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Test.Models;

namespace Test.Services
{
    public class MockDataStore : IDataStore<Item>
    {
        readonly List<Item> items;

        public MockDataStore()
        {
            items = new List<Item>
            {
                new Item
                {
                    Id = Guid.NewGuid().ToString(),
                    Name = "Small farm",
                    Address = "123 Somewhere Place, City",
                    Size = 50,
                    IsFarm = true,
                    Entities = new List<Entity>
                    {
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 1", Amount = 1, PurchaseDate = "2020-10-11", Cost = 100.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 2", Amount = 2, PurchaseDate = "2020-10-12", Cost = 200.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 3", Amount = 3, PurchaseDate = "2020-10-13", Cost = 300.00f, Sold = false, Note = "This is a note."
                        },
                    }
                },
                new Item
                {
                    Id = Guid.NewGuid().ToString(),
                    Name = "Large farm",
                    Address = "123 Somewhere Place, City",
                    IsFarm = true,
                    Size = 50,
                    Entities = new List<Entity>
                    {
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 1", Amount = 1, PurchaseDate = "2020-10-11", Cost = 100.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 2", Amount = 2, PurchaseDate = "2020-10-12", Cost = 200.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 3", Amount = 3, PurchaseDate = "2020-10-13", Cost = 300.00f, Sold = false, Note = "This is a note."
                        },
                    }
                },
                new Item
                {
                    Id = Guid.NewGuid().ToString(),
                    Name = "Plants at home",
                    Address = "123 Somewhere Place, City",
                    Size = 50,
                    IsFarm = true,
                    Entities = new List<Entity>
                    {
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 1", Amount = 1, PurchaseDate = "2020-10-11", Cost = 100.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 2", Amount = 2, PurchaseDate = "2020-10-12", Cost = 200.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 3", Amount = 3, PurchaseDate = "2020-10-13", Cost = 300.00f, Sold = false, Note = "This is a note."
                        },
                    }
                },
                new Item
                {
                    Id = Guid.NewGuid().ToString(),
                    Name = "Another small farm",
                    Address = "123 Somewhere Place, City",
                    Size = 50,
                    IsFarm = true,
                    Entities = new List<Entity>
                    {
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 1", Amount = 1, PurchaseDate = "2020-10-11", Cost = 100.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 2", Amount = 2, PurchaseDate = "2020-10-12", Cost = 200.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 3", Amount = 3, PurchaseDate = "2020-10-13", Cost = 300.00f, Sold = false, Note = "This is a note."
                        },
                    }
                },
                new Item
                {
                    Id = Guid.NewGuid().ToString(),
                    Name = "Large farm",
                    Address = "123 Somewhere Place, City",
                    Size = 500,
                    IsFarm = true,
                    Entities = new List<Entity>
                    {
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 1", Amount = 1, PurchaseDate = "2020-10-11", Cost = 100.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 2", Amount = 2, PurchaseDate = "2020-10-12", Cost = 200.00f, Sold = false, Note = "This is a note."
                        },
                        new Entity
                        {
                            Id = Guid.NewGuid().ToString(), Name = "Plant 3", Amount = 3, PurchaseDate = "2020-10-13", Cost = 300.00f, Sold = false, Note = "This is a note."
                        },
                    }
                },
            };
        }

        public async Task<bool> AddItemAsync(Item item)
        {
            items.Add(item);
            return await Task.FromResult(true);
        }

        public async Task<bool> UpdateItemAsync(Item item)
        {
            var oldItem = items.Where((Item arg) => arg.Id == item.Id).FirstOrDefault();
            items.Remove(oldItem);
            items.Add(item);
            return await Task.FromResult(true);
        }

        public async Task<bool> DeleteItemAsync(string id)
        {
            var oldItem = items.Where((Item arg) => arg.Id == id).FirstOrDefault();
            items.Remove(oldItem);
            return await Task.FromResult(true);
        }

        public async Task<Item> GetItemAsync(string id)
        {
            return await Task.FromResult(items.FirstOrDefault(s => s.Id == id));
        }

        public async Task<IEnumerable<Item>> GetItemsAsync(bool forceRefresh = false)
        {
            return await Task.FromResult(items);
        }

        public async Task<IEnumerable<Entity>> GetEntitiesAsync(string id, bool forceRefresh = false)
        {
            return await Task.FromResult(items.FirstOrDefault(s => s.Id == id).Entities);
        }
    }
}