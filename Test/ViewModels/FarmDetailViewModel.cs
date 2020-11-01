using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Threading.Tasks;
using Test.Models;
using Test.Views;
using Xamarin.Forms;

namespace Test.ViewModels
{
    [QueryProperty(nameof(ItemId), nameof(ItemId))]
    public class FarmDetailViewModel : BaseViewModel
    {
        private string itemId;
        private string text;
        private string description;
        public string Id { get; set; }

        public Command EditItemCommand { get; }
        public Command DeleteItemCommand { get; }

        private Entity _selectedItem;


        public ObservableCollection<Entity> Entities { get; }
        public Command LoadItemsCommand { get; }
        public Command AddItemCommand { get; }
        public Command<Entity> ItemTapped { get; }


        public FarmDetailViewModel()
        {
            EditItemCommand = new Command<Item>(OnEditItem);
            DeleteItemCommand = new Command<Item>(OnDeleteItem);
            Title = "My Farms";
            Entities = new ObservableCollection<Entity>();
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());
            ItemTapped = new Command<Entity>(OnItemSelected);
            AddItemCommand = new Command(OnAddItem);
        }

        public void OnAppearing()
        {
            IsBusy = true;
            SelectedItem = null;
        }

        public Entity SelectedItem
        {
            get => _selectedItem;
            set
            {
                SetProperty(ref _selectedItem, value);
                OnItemSelected(value);
            }
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

        async Task ExecuteLoadItemsCommand()
        {
            IsBusy = true;

            try
            {
                Entities.Clear();
                var entities = await DataStore.GetEntitiesAsync(ItemId,true);
                foreach (var entity in entities)
                {
                    Entities.Add(entity);
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
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

        private async void OnAddItem(object obj)
        {
            await Shell.Current.GoToAsync(nameof(NewItemPage));
        }

        async void OnItemSelected(Entity item)
        {
            if (item == null)
                return;
            // This will push the ItemDetailPage onto the navigation stack
            await Shell.Current.GoToAsync($"{nameof(FarmDetailPage)}?{nameof(FarmDetailViewModel.ItemId)}={item.Id}");

        }
    }
}