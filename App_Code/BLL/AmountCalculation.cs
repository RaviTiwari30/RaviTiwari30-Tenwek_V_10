using System.Data;

/// <summary>
/// Summary description for AmountCalculation
/// </summary>
public class AmountCalculation
{
    public AmountCalculation()
    {
        //
        // TODO: Add constructor logic here
        //
    }


    public decimal getAmount(decimal Rate, decimal DiscPercent, decimal TaxAmt)
    {


        decimal exciseAmt = 0;
        decimal UnitPrice = 0;
   
        //foreach (DataRow dr in TaxTable.Rows)
        //{
        //    if (Util.GetString(dr["TaxID"]) == "T5")
        //    {
        //        if (Util.GetFloat(dr["TaxAmt"]) > 0)
        //        {
        //            exciseAmt = Util.GetFloat(dr["TaxAmt"]);
        //        }
        //        else if (Util.GetFloat(dr["TaxPer"]) > 0)
        //        {
        //            exciseAmt = Rate * Util.GetFloat(dr["TaxPer"]) / 100;
        //        }
        //    }
        //    else if (Util.GetString(dr["TaxID"]) == "T3")
        //    {
        //        if (Util.GetFloat(dr["TaxAmt"]) > 0)
        //        {
        //            newVatRate = (Rate * ((100 - DiscPercent) / 100)) + Util.GetFloat(dr["TaxAmt"]);
        //        }
        //        else if (Util.GetFloat(dr["TaxPer"]) > 0)
        //        {
        //            newVatRate = (Rate * ((100 - DiscPercent) / 100)) + ((Rate * ((100 - DiscPercent) / 100)) * Util.GetFloat(dr["TaxPer"]) / 100);
        //        }
        //        totTax += Util.GetFloat(dr["TaxPer"]);
        //    }
        //    else if (Util.GetString(dr["TaxID"]) == "T7")
        //    { 
        //    }
        //    else
        //    {
        //        totTax += Util.GetFloat(dr["TaxPer"]);
        //    }

        //}

        //foreach (DataRow dr in TaxTable.Rows)
        //{
            
        //    if (Util.GetString(dr["TaxID"]) == "T7")
        //    {
                
        //         if (Util.GetFloat(dr["TaxAmt"]) > 0)
        //         {
        //            CesstaxAmt = newVatRate*(Util.GetFloat(dr["TaxPer"]) / 100);
        //         }
        //         else if (Util.GetFloat(dr["TaxPer"]) > 0)
        //         {
        //             CesstaxAmt = newVatRate * (Util.GetFloat(dr["TaxPer"]) / 100);
        //         }
        //    }
            

        //}


        decimal a = (Rate - exciseAmt);
        a = a * ((100 - DiscPercent) / 100);
        //a = a + exciseAmt;
      //  UnitPrice = (a * ((100 + totTax) / 100)) + CesstaxAmt;
        UnitPrice = a+TaxAmt;
        return UnitPrice;

    }


    public decimal getAmount(decimal Rate, decimal DiscPercent, DataTable TaxTable)
    {

        decimal totTax = 0;
        decimal exciseAmt = 0;
        decimal UnitPrice = 0;
        decimal newVatRate = 0;
        decimal CesstaxAmt = 0;
        foreach (DataRow dr in TaxTable.Rows)
        {
            if (Util.GetString(dr["TaxID"]) == "T5")
            {
                if (Util.GetFloat(dr["TaxAmt"]) > 0)
                {
                    exciseAmt = Util.GetDecimal(dr["TaxAmt"]);
                }
                else if (Util.GetFloat(dr["TaxPer"]) > 0)
                {
                    exciseAmt = Rate * Util.GetDecimal(dr["TaxPer"]) / 100;
                }
            }
            else if (Util.GetString(dr["TaxID"]) == "T3")
            {
                if (Util.GetFloat(dr["TaxAmt"]) > 0)
                {
                    newVatRate = (Rate * ((100 - DiscPercent) / 100)) + Util.GetDecimal(dr["TaxAmt"]);
                }
                else if (Util.GetFloat(dr["TaxPer"]) > 0)
                {
                    newVatRate = (Rate * ((100 - DiscPercent) / 100)) + ((Rate * ((100 - DiscPercent) / 100)) * Util.GetDecimal(dr["TaxPer"]) / 100);
                }
                totTax += Util.GetDecimal(dr["TaxPer"]);
            }
            else if (Util.GetString(dr["TaxID"]) == "T7")
            {
            }
            else
            {
                totTax += Util.GetDecimal(dr["TaxPer"]);
            }

        }

        foreach (DataRow dr in TaxTable.Rows)
        {

            if (Util.GetString(dr["TaxID"]) == "T7")
            {

                if (Util.GetFloat(dr["TaxAmt"]) > 0)
                {
                    CesstaxAmt = newVatRate * (Util.GetDecimal(dr["TaxPer"]) / 100);
                }
                else if (Util.GetFloat(dr["TaxPer"]) > 0)
                {
                    CesstaxAmt = newVatRate * (Util.GetDecimal(dr["TaxPer"]) / 100);
                }
            }


        }


        decimal a = (Rate - exciseAmt);
        a = a * ((100 - DiscPercent) / 100);
        a = a + exciseAmt;
         UnitPrice = (a * ((100 + totTax) / 100)) + CesstaxAmt;
        //UnitPrice = a ;
        return UnitPrice;

    }


    public decimal getAmountnew(decimal Rate, decimal DiscPercent, DataTable TaxTable)
    {

        decimal totTax = 0;
        decimal exciseAmt = 0;
        decimal UnitPrice = 0;
        decimal newVatRate = 0;
        decimal CesstaxAmt = 0;
        foreach (DataRow dr in TaxTable.Rows)
        {
            if (Util.GetString(dr["TaxID"]) == "T5")
            {
                if (Util.GetDecimal(dr["TaxAmt"]) > 0)
                {
                    exciseAmt = Util.GetDecimal(dr["TaxAmt"]);
                }
                else if (Util.GetDecimal(dr["Tax"]) > 0)
                {
                    exciseAmt = Rate * Util.GetDecimal(dr["Tax"]) / 100;
                }
            }
            else if (Util.GetString(dr["TaxID"]) == "T3")
            {

                if (Util.GetDecimal(dr["Tax"]) > 0)
                {
                    newVatRate = (Rate * ((100 - DiscPercent) / 100)) + ((Rate * ((100 - DiscPercent) / 100)) * Util.GetDecimal(dr["Tax"]) / 100);
                }
                totTax += Util.GetDecimal(dr["Tax"]);
            }
            else if (Util.GetString(dr["TaxID"]) == "T7")
            {
            }
            else
            {
                totTax += Util.GetDecimal(dr["Tax"]);
            }

        }

        foreach (DataRow dr in TaxTable.Rows)
        {

            if (Util.GetString(dr["TaxID"]) == "T7")
            {


                if (Util.GetDecimal(dr["Tax"]) > 0)
                {
                    CesstaxAmt = newVatRate * (Util.GetDecimal(dr["Tax"]) / 100);
                }
            }


        }


        decimal a = (Rate - exciseAmt);
        a = a * ((100 - DiscPercent) / 100);
        a = a + exciseAmt;
        UnitPrice = (a * ((100 + totTax) / 100)) + CesstaxAmt;
        //UnitPrice = a ;
        return UnitPrice;

    }

    public decimal getAmount(decimal Rate, decimal DiscPercent, DataTable TaxTable,decimal Qty)
    {

        decimal totTax = 0;
        decimal exciseAmt = 0;
        decimal UnitPrice = 0;
        decimal newVatRate = 0;
        decimal CesstaxAmt = 0;
        foreach (DataRow dr in TaxTable.Rows)
        {
            if (Util.GetString(dr["TaxID"]) == "T5")
            {
                if (Util.GetDecimal(dr["TaxAmt"]) > 0)
                {
                    exciseAmt = Util.GetDecimal(dr["TaxAmt"]);
                }
                else if (Util.GetDecimal(dr["TaxPer"]) > 0)
                {
                    exciseAmt = Rate * Util.GetDecimal(dr["TaxPer"]) / 100;
                }
            }
            else if (Util.GetString(dr["TaxID"]) == "T3")
            {
                if (Util.GetFloat(dr["TaxAmt"]) > 0)
                {
                    newVatRate = (Rate * ((100 - DiscPercent) / 100)) + Util.GetDecimal(dr["TaxAmt"]);
                }
                else if (Util.GetDecimal(dr["TaxPer"]) > 0)
                {
                    newVatRate = (Rate * ((100 - DiscPercent) / 100)) + ((Rate * ((100 - DiscPercent) / 100)) * Util.GetDecimal(dr["TaxPer"]) / 100);
                }
                totTax += Util.GetDecimal(dr["TaxPer"]);
            }
            else if (Util.GetString(dr["TaxID"]) == "T7")
            {
            }
            else
            {
                totTax += Util.GetDecimal(dr["TaxPer"]);
            }

        }

        foreach (DataRow dr in TaxTable.Rows)
        {

            if (Util.GetString(dr["TaxID"]) == "T7")
            {

                if (Util.GetFloat(dr["TaxAmt"]) > 0)
                {
                    CesstaxAmt = (newVatRate * (Util.GetDecimal(dr["TaxPer"]) / 100)) * Qty;
                }
                else if (Util.GetFloat(dr["TaxPer"]) > 0)
                {
                    CesstaxAmt = (newVatRate * (Util.GetDecimal(dr["TaxPer"]) / 100)) * Qty;
                }
            }


        }


        decimal a = (Rate - exciseAmt);
        a = a * ((100 - DiscPercent) / 100);
        a = a + exciseAmt;
        UnitPrice = ((a * ((100 + totTax) / 100)) * Qty) + CesstaxAmt;
        //UnitPrice = a ;
        return UnitPrice;

    }





}
