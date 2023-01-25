using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ConvertCurrencyInWord
/// </summary>
public static class ConvertCurrencyInWord
{
	

    public static string AmountInWord(decimal number, string Currency)
    {
        string word = string.Empty;
      
        System.Globalization.CultureInfo  culInfo = new System.Globalization.CultureInfo("en-US");
        
        
        int num1 = Convert.ToInt32(Convert.ToString(number, culInfo.NumberFormat).Split('.')[0]);

        int num2 = 0;
        if (number.ToString().Split('.').Length > 1)
        {
            num2 = Convert.ToInt32(number.ToString().Split('.')[1]);
        }

        string rupee = NumberToWords(num1);
        string paisa = string.Empty;
        if (num2 > 0)
        {
            paisa = NumberToWords(num2);
        }
        if (Currency == "USD")
        {
            word = rupee + " dollars";
            if (paisa.Length > 0)
            {
                word += " and " + paisa + " cent";
            }
        }
        else if (Currency == "GHC" || Currency == "CEDI")
        {
            word = rupee + " cedi";
            if (paisa.Length > 0)
            {
                word += " and " + paisa + " pesewas";
            }
        }
        else if (Currency == "KES" || Currency == "Ksh")
        {
            word = " KSH : " + rupee ;
            if (paisa.Length > 0)
            {
                word += " and " + paisa + " pesewas";
            }
        }
        else if (Currency == "EUR")
        {
            word = rupee + " pounds";
            if (paisa.Length > 0)
            {
                word += " and " + paisa + " pence";
            }
        }
        else if (Currency == "Ringgit" || Currency=="MYR")
        {
            word = rupee + " Ringgit";
            if (paisa.Length > 0)
            {
                word += " and " + paisa + " cent";
            }
        }
        else if (Currency == "INR" || Currency == "Rupee" || Currency == "MUR")
        {
            //Seprate Function use for INR
            word = StockReports.ChangeNumericToWords(Convert.ToString(Math.Round(number, 0)));
        }
        return word;
    }
    public static string NumberToWords(int number)
    {
        if (number == 0)
            return "zero";

        if (number < 0)
            return "minus " + NumberToWords(Math.Abs(number));

        string words = "";

        if ((number / 1000000) > 0)
        {
            words += NumberToWords(number / 1000000) + " million ";
            number %= 1000000;
        }

        if ((number / 1000) > 0)
        {
            words += NumberToWords(number / 1000) + " thousand ";
            number %= 1000;
        }

        if ((number / 100) > 0)
        {
            words += NumberToWords(number / 100) + " hundred ";
            number %= 100;
        }

        if (number > 0)
        {
            if (words != "")
                words += "and ";

            var unitsMap = new[] { "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen" };
            var tensMap = new[] { "Zero", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

            if (number < 20)
                words += unitsMap[number];
            else
            {
                words += tensMap[number / 10];
                if ((number % 10) > 0)
                    words += "-" + unitsMap[number % 10];
            }
        }

        return words;
    }

}