﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Mortuary_Mortuary_PostMortemReport : System.Web.UI.Page
{   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            lblUser.Text = Session["ID"].ToString();

            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        
        txtFromDate.Attributes.Add("readOnly", "readOnly");
       // txtToDate.Attributes.Add("readOnly", "readOnly");
    }
}