using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace Test.Converters
{
    class FarmBarnToImageConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            switch ((bool) value)
            {
                case true:
                    return "tree1.png";
                case false:
                    return "dog.png";
            }

            return Color.Gray;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            // You probably don't need this, this is used to convert the other way around
            // so from color to yes no or maybe
            throw new NotImplementedException();
        }
    }
}
