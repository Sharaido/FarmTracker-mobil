using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Test.Models;
using Xamarin.Forms;

namespace Test.ViewModels
{
    [QueryProperty(nameof(ItemId), nameof(ItemId))]
    public class ItemDetailViewModel : BaseViewModel
    {
        private string itemId;
        private string text;
        private string description;
        public string Id { get; set; }

        public Command EditItemCommand { get; }
        public Command DeleteItemCommand { get; }


        public ItemDetailViewModel()
        {
            EditItemCommand = new Command<Item>(OnEditItem);
            DeleteItemCommand = new Command<Item>(OnDeleteItem);
        }

        public string Text
        {
            get => text;
            set => SetProperty(ref text, value);
        }

        public string Description
        {
            get => description;
            set => SetProperty(ref description, value);
        }

        public string ItemId
        {
            get => itemId;
            set
            {
                itemId = value;
                LoadItemId(value);
            }
        }

        private async void LoadItemId(string itemIdToLoad)
        {
            try
            {
                var item = await DataStore.GetItemAsync(itemIdToLoad);
                Id = item.Id;
                Text = item.Name;
                Description = item.Description;
            }
            catch (Exception)
            {
                Debug.WriteLine("Failed to Load Item");
            }
        }

        private async void OnEditItem(object obj)
        {
            var item = new Item {Id = itemId, Name = text, Description = description};

            await DataStore.UpdateItemAsync(item);
            await Shell.Current.GoToAsync("..");
        }

        private async void OnDeleteItem(object obj)
        {
            await DataStore.DeleteItemAsync(itemId);
            await Shell.Current.GoToAsync("..");
        }
    }
}