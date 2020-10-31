using System.ComponentModel;
using Xamarin.Forms;
using Test.ViewModels;

namespace Test.Views
{
    public partial class ItemDetailPage : ContentPage
    {
        public ItemDetailPage()
        {
            InitializeComponent();
            BindingContext = new ItemDetailViewModel();
        }
    }
}