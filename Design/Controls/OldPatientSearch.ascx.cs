using System;
using System.Collections.Generic;
public partial class Design_Controls_OldPatientSearch : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
               txtSearchModelFromDate.Text =txtSerachModelToDate.Text= txtModelDOB.Text=  System.DateTime.Now.ToString("dd-MMM-yyyy");
               CalendarExteDOB.EndDate = calExdTxtSearchModelFromDate.EndDate = calExdTxtSerachModelToDate.EndDate =  CalExtTxtModelDOB.EndDate =System.DateTime.Now;           
        }
       
        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");
   


    }
}