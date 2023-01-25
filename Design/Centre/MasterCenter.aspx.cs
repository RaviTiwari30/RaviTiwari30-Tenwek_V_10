using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.IO;
using System.Web.Services;

using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Centre_MasterCenter : System.Web.UI.Page
{
    private DataTable dt = new DataTable();

    private void BindCentre()
    {
        DataTable dtcentre = StockReports.GetDataTable(" select CentreID,CentreName,IsDefault from center_master Where IsActive=1 and CentreID=FollowedCentreId order by CentreName");
        ddlFollowedCentre.DataSource = dtcentre;
        ddlFollowedCentre.DataTextField = "CentreName";
        ddlFollowedCentre.DataValueField = "CentreID";
        ddlFollowedCentre.DataBind();
        ddlFollowedCentre.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void BindCountry()
    {

        DataTable dtCountry = StockReports.GetDataTable(" SELECT NAME AS TextField,CountryID AS ValueField FROM country_master WHERE IsActive=1 ORDER BY TextField ");
        ddlCountry.DataSource = dtCountry;
        ddlCountry.DataTextField = "TextField";
        ddlCountry.DataValueField = "ValueField";
        ddlCountry.DataBind();
        ddlCountry.Items.Insert(0, new ListItem("Select", "0"));
        ddlCountry.SelectedIndex = ddlCountry.Items.IndexOf(ddlCountry.Items.FindByValue(Resources.Resource.BaseCurrencyID));
    }
    private void BindState()
    {

        DataTable dtState = StockReports.GetDataTable(" SELECT StateName AS TextField,StateID AS ValueField FROM master_State WHERE IsActive=1 AND StateName<>'' and CountryID='" + ddlCountry.SelectedItem.Value + "' ORDER BY TextField ");
        ddlState.DataSource = dtState;
        ddlState.DataTextField = "TextField";
        ddlState.DataValueField = "ValueField";
        ddlState.DataBind();
        ddlState.Items.Insert(0, new ListItem("Select", "0"));
        ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(Resources.Resource.DefaultStateID));
    }
    private void BindDistrict()
    {

        DataTable dtDistrict = StockReports.GetDataTable(" SELECT District AS TextField,DistrictID AS ValueField FROM Master_District WHERE IsActive=1 AND District<>'' and CountryID='" + ddlCountry.SelectedItem.Value + "' and StateID='" + ddlState.SelectedItem.Value + "' ORDER BY TextField ");
        ddlDistrict.DataSource = dtDistrict;
        ddlDistrict.DataTextField = "TextField";
        ddlDistrict.DataValueField = "ValueField";
        ddlDistrict.DataBind();
        ddlDistrict.Items.Insert(0, new ListItem("Select", "0"));
        ddlDistrict.SelectedIndex = ddlDistrict.Items.IndexOf(ddlDistrict.Items.FindByValue(Resources.Resource.DefaultDistrictID));
    }

    private void BindCity()
    {

        DataTable dtCity = StockReports.GetDataTable(" SELECT City AS TextField,ID AS ValueField FROM city_master WHERE IsActive=1 AND city !='' AND IFNULL(districtID,0)<>0 and DistrictID='" + ddlDistrict.SelectedItem.Value + "' and StateID='" + ddlState.SelectedItem.Value + "' ORDER BY TextField ");
        ddlCity.DataSource = dtCity;
        ddlCity.DataTextField = "TextField";
        ddlCity.DataValueField = "ValueField";
        ddlCity.DataBind();
        ddlCity.Items.Insert(0, new ListItem("Select", "0"));
        ddlCity.SelectedIndex = ddlCity.Items.IndexOf(ddlCity.Items.FindByValue(Resources.Resource.DefaultCityID));
    }


    protected void btnAdd_Click(object sender, EventArgs e)
    {
        try
        {
            string ID = "";

            foreach (GridViewRow grv in grdOption.Rows)
            {
                if (((CheckBox)grv.FindControl("chkSelect")).Checked)
                {
                    if (ID == "")
                        ID = ((Label)grv.FindControl("lblID")).Text;
                    else
                        ID += "," + ((Label)grv.FindControl("lblID")).Text;
                }
            }

            if (lblIsOpened.Text == "D")
                ViewState["DoctorID"] = ID;

            if (lblIsOpened.Text == "P")
                ViewState["PanelID"] = ID;

            if (lblIsOpened.Text == "UpdateDoctor")
                ViewState["DoctorID"] = ID;

            if (lblIsOpened.Text == "UpdatePanel")
                ViewState["PanelID"] = ID;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator";
        }
    }

    //protected void btnDoctor_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        if (ViewState["CenterMasterID"].ToString() != "")
    //        {
    //            Filldata("EditDoctor");
    //            lblIsOpened.Text = "UpdateDoctor";
    //            mdlView.Show();
    //        }
    //        else
    //        {
    //            Filldata("D");
    //            lblIsOpened.Text = "D";
    //            mdlView.Show();
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //    }
    //}

    //protected void btnPanel_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        if (ViewState["CenterMasterID"].ToString() != "")
    //        {
    //            Filldata("EditPanel");
    //            lblIsOpened.Text = "UpdatePanel";
    //            mdlView.Show();
    //        }
    //        else
    //        {
    //            Filldata("P");
    //            lblIsOpened.Text = "P";
    //            mdlView.Show();
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //        lblMsg.Text = "Error occurred, Please contact administrator";
    //    }
    //}

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (txtCName.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Centre Name";
            txtCName.Focus();
            return;
        }
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from center_master where CentreName='" + txtCName.Text.Trim() + "'"));

        if (count > 0)
        {
            lblMsg.Text = "Centre Already Registered";
            txtCName.Focus();
            return;
        }

        if (chkSelf.Checked)
        {
            int isPrefix = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from center_master where InitialChar='" + Util.GetString(txtInitialChar.Text.Trim()) + "' AND FollowedCentreId=CentreID "));

            if (isPrefix > 0)
            {
                lblMsg.Text = "Prefix Already Mapped with another Centre";
                txtInitialChar.Focus();
                return;
            }
        }

        if (txtccode.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Centre Code";
            txtccode.Focus();
            return;
        }

        if (txtMobile.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Contact No.";
            txtMobile.Focus();
            return;
        }
        if (txtMobile.Text.Length < 10)
        {
            lblMsg.Text = "Please Enter 10 digit Contact No.";
            txtMobile.Focus();
            return;
        }

        if (ddlDiscount.SelectedItem.Value == "Select")
        {
            lblMsg.Text = "Please select Discount Type";
            txtMobile.Focus();
            return;
        }
        if (txtCAddress.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Address";
            txtCAddress.Focus();
            return;
        }

        if (ddlCountry.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select Country";
            ddlCountry.Focus();
            return;
        }
        if (ddlState.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select State";
            ddlState.Focus();
            return;
        }
        if (ddlDistrict.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select District";
            ddlDistrict.Focus();
            return;
        }
        if (ddlCity.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select City";
            ddlCity.Focus();
            return;
        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            Center_Master objCM = new Center_Master(tnx);
            objCM.CentreCode = txtccode.Text.Trim();
            objCM.CentreName = txtCName.Text.Trim();
            objCM.Website = txtWebsite.Text.Trim();
            objCM.Address = txtCAddress.Text.Trim();
            objCM.MobileNo = txtMobile.Text.Trim();
            objCM.LandlineNo = txtLandline.Text.Trim();
            objCM.EmailID = txtMail.Text.Trim();
            objCM.DiscountType = ddlDiscount.SelectedValue;
            objCM.IsDefault = 0;
            objCM.Latitude = txtLatitude.Text.Trim();
            objCM.Longitude = txtLongitude.Text.Trim();

            string CentreID = objCM.Insert().ToString();

            int FollowedCentre = Util.GetInt(ddlFollowedCentre.SelectedItem.Value.Trim());
            string InitialChar = "";

            if (chkSelf.Checked)
            {
                FollowedCentre = Util.GetInt(CentreID);
                InitialChar = Util.GetString(txtInitialChar.Text.Trim());
            }
            string nablfilename = string.Empty;
            if (flIsNabl.HasFile)
                nablfilename = UploadImage(flIsNabl);
            string iscapfilename = string.Empty;
            if (flIsCap.HasFile)
                iscapfilename = UploadImage(flIsCap);
            string centerlogo = string.Empty;
            if (HeaderLogoCrystalReport.HasFile)
                centerlogo = UploadImage(HeaderLogoCrystalReport);
            string footerlogo = string.Empty;
            if (footerLogoCrystalReport.HasFile)
                footerlogo = UploadImage(footerLogoCrystalReport);
            StringBuilder sb= new StringBuilder();
            sb.Append("update center_master set FollowedCentreId=" + FollowedCentre + ",InitialChar='" + InitialChar + "' ");
            if(!String.IsNullOrEmpty(centerlogo))
                sb.Append(" ,ReportHeaderURL='" + centerlogo.Trim() + "' ");
            if(!String.IsNullOrEmpty(footerlogo))
                sb.Append(" ,ReportFooterURL='" + footerlogo.Trim() + "' ");
            if(!String.IsNullOrEmpty(nablfilename))
                sb.Append(" ,NablLogoPath='" + nablfilename.Trim() + "' ");
            sb.Append(" ,IsNableCentre='" + Util.getbooleanInt(Util.GetBoolean(chkIsNablCenter.Checked)) + "' ");
            if(!String.IsNullOrEmpty(iscapfilename))
                sb.Append(" ,CapLogoPath='" + iscapfilename.Trim() + "' ");
            sb.Append(" ,isCap='" + Util.getbooleanInt(Util.GetBoolean(chkIsCap.Checked)) + "' ");
            sb.Append(" ,PrePrintedBarcode='" + Util.getbooleanInt(Util.GetBoolean(chkPrePrintedBarcode.Checked)) + "' ");
            if (txtPrePrintedBarcode.Text.Trim().Length == 1 && chkPrePrintedBarcode.Checked)
                sb.Append(" ,LabBarcodeAbbreviation='" + txtPrePrintedBarcode.Text.Trim() + "' ");

            sb.Append(" ,CountryID='" + ddlCountry.SelectedItem.Value + "' , Country='" + ddlCountry.SelectedItem.Text + "' , StateID='" + ddlState.SelectedItem.Value + "' , State='" + ddlState.SelectedItem.Text + "' , DistrictID='" + ddlDistrict.SelectedItem.Value + "' , District='" + ddlDistrict.SelectedItem.Text + "' , CityID='" + ddlCity.SelectedItem.Value + "' , City='" + ddlCity.SelectedItem.Text + "' ");
          
            sb.Append(" where CentreId=" + Util.GetInt(CentreID) + "");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            if (ViewState["DoctorID"] != null && ViewState["DoctorID"].ToString() != "")
            {
                string[] str = ViewState["DoctorID"].ToString().Split(',');

                foreach (string s in str)
                {
                    string SqlDoctor = "insert into f_center_doctor(DoctorID,CentreID,CreatedBy) values('" + s + "','" + CentreID + "','" + Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, SqlDoctor);
                }

                ViewState["DoctorID"] = "";
            }

            if (ViewState["PanelID"] != null && ViewState["PanelID"].ToString() != "")
            {
                string[] str = ViewState["PanelID"].ToString().Split(',');

                foreach (string s in str)
                {
                    string SqlPanel = "insert into f_center_panel(PanelID,CentreID,CreatedBy) values('" + s + "','" + CentreID + "','" + Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, SqlPanel);
                }

                ViewState["PanelID"] = "";
            }

           
            tnx.Commit();

           // UploadCenterHeaderImage(Session["CentreID"].ToString());
            //UploadCenterFooterImage(Session["CentreID"].ToString());
            fillGrid();

         //  ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UniqueKey1", "modelAlert('Record Saved Successfully')", true);

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UniqueKey1", "modelConfirmation('Map Panel,Role and Doctor', 'Do You Want To Map Panel and Doctor?', 'Yes', 'Close', function (response) { if (response) { window.open('../EDP/CentreWiseMapping.aspx?CID=" + CentreID + "'); } });", true);



            lblMsg.Text = "Record Saved Successfully";
            reset();
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
   protected void UploadCenterHeaderImage(string CentreID)
    {
        if (HeaderLogoCrystalReport.HasFile)
        {
            string Exte = System.IO.Path.GetExtension(HeaderLogoCrystalReport.PostedFile.FileName);
            string name = HeaderLogoCrystalReport.FileName;
            if (Exte != "")
            {
                if (Exte != ".jpg" && Exte != ".jpeg" && Exte != ".JPG" && Exte != ".png")
                {
                    lblMsg.Text = "Wrong File Extension of Header ";
                    return;
                }
            }


            //string Url = Server.MapPath("Images/" + name);
            string Url = Server.MapPath("~/Images/" + name);
            if (File.Exists(Url))
            {
                File.Delete(Url);
            }
            
                HeaderLogoCrystalReport.PostedFile.SaveAs(Url);
                Url = Url.Replace("\\", "''");
                Url = Url.Replace("'", "\\");
                string str = "Update Center_Master set ReportHeaderURL='" + name + "' where CentreID='" + CentreID + "'";
                StockReports.ExecuteDML(str);

        }
    }
   protected void UploadCenterFooterImage(string CentreID)
   {
       if (footerLogoCrystalReport.HasFile)
       {
           string Exte = System.IO.Path.GetExtension(footerLogoCrystalReport.PostedFile.FileName);
           string name = footerLogoCrystalReport.FileName;
           if (Exte != "")
           {
               if (Exte != ".jpg" && Exte != ".jpeg" && Exte != ".JPG" && Exte != ".png")
               {
                   lblMsg.Text = "Wrong File Extension of Header ";
                   return;
               }
           }


           string Url = Server.MapPath("~/Images/" + name);
           if (File.Exists(Url))
           {
               File.Delete(Url);
           }

           footerLogoCrystalReport.PostedFile.SaveAs(Url);
           Url = Url.Replace("\\", "''");
           Url = Url.Replace("'", "\\");
           string str = "Update Center_Master set ReportFooterURL='" + name + "' where CentreID='" + CentreID + "'";
           StockReports.ExecuteDML(str);

       }
   }
   private string UploadImage(FileUpload fl)
   {
       string name = string.Empty;
       if (fl.HasFile)
       {
           string Exte = System.IO.Path.GetExtension(fl.PostedFile.FileName);
           name = fl.FileName;
           if (Exte != "")
           {
               if (Exte != ".jpg" && Exte != ".jpeg" && Exte != ".JPG" && Exte != ".png")
               {
                   lblMsg.Text = "Wrong File Extension of Header ";
                   return "ERROR";
               }
           }
           //string Url = Server.MapPath("Images/" + name);
           string Url = Server.MapPath("~/Images/" + name);
           if (File.Exists(Url))
           {
               File.Delete(Url);
           }

           fl.PostedFile.SaveAs(Url);
           Url = Url.Replace("\\", "''");
           Url = Url.Replace("'", "\\");
           //string str = "Update Center_Master set ReportHeaderURL='" + name + "' where CentreID='" + CentreID + "'";
           //StockReports.ExecuteDML(str);

       }
       return name;
   }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (txtCName.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Centre Name";
            txtCName.Focus();
            return;
        }

        if (txtccode.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Centre Code";
            txtccode.Focus();
            return;
        }

        if (txtMobile.Text.Trim() == "")
        {
            string Msg = "Please Enter Contact No.";
            lblMsg.Text = Msg;
            txtMobile.Focus();
            return;
        }
        if (txtMobile.Text.Length < 10)
        {
            lblMsg.Text = "Please Enter 10 digit Contact No.";
            txtMobile.Focus();
            return;
        }

        if (ddlDiscount.SelectedItem.Value == "Select")
        {
            lblMsg.Text = "Please Select Discount Type";
            txtMobile.Focus();
            return;
        }

        if (txtCAddress.Text.Trim() == "")
        {
            lblMsg.Text = "Please Enter Address";
            txtCAddress.Focus();
            return;
        }

        if (ddlCountry.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select Country";
            ddlCountry.Focus();
            return;
        }
        if (ddlState.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select State";
            ddlState.Focus();
            return;
        }
        if (ddlDistrict.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select District";
            ddlDistrict.Focus();
            return;
        }
        if (ddlCity.SelectedItem.Value == "0")
        {
            lblMsg.Text = "Please Select City";
            ddlCity.Focus();
            return;
        }

        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from center_master where CentreName='" + txtCName.Text.Trim() + "' and CentreId<>" + Util.GetInt(ViewState["CenterMasterID"].ToString()) + " "));

        if (count > 0)
        {
            lblMsg.Text = "Centre Already Registered";
            txtCName.Focus();
            return;
        }

        if (chkSelf.Checked)
        {
            int isPrefix = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from center_master where InitialChar='" + Util.GetString(txtInitialChar.Text.Trim()) + "'  and CentreId<>" + Util.GetInt(ViewState["CenterMasterID"].ToString()) + "  AND FollowedCentreId=CentreID "));

            if (isPrefix > 0)
            {
                lblMsg.Text = "Prefix Already Mapped with another Centre";
                txtInitialChar.Focus();
                return;
            }
        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            int IsDefault = 0;
           
            int FollowedCentre = Util.GetInt(ddlFollowedCentre.SelectedItem.Value.Trim());
            string InitialChar = "";

            if (chkSelf.Checked)
            {
                FollowedCentre = Util.GetInt(ViewState["CenterMasterID"].ToString());
                InitialChar = Util.GetString(txtInitialChar.Text.Trim());
            }

            //string SQL = "UPDATE center_master SET FollowedCentreId=" + FollowedCentre + ",InitialChar='" + InitialChar + "',CentreCode='" + txtccode.Text.Trim() + "',CentreName='" + txtCName.Text.Trim() + "',Website='" + txtWebsite.Text.Trim() + "',Address='" + txtCAddress.Text.Trim() + "',MobileNo= '" + txtMobile.Text.Trim() + "',LandlineNo='" + txtLandline.Text.Trim() + "',EmailID='" + txtMail.Text.Trim() + "',IsActive= '" + rbtActive.SelectedValue + "',DiscountType='" + ddlDiscount.SelectedValue + "',UpdateDate= '" + System.DateTime.Now.ToString("yyyy-MM-dd") + "',IsDefault=" + IsDefault + ",Latitude='" + Util.GetString(txtLatitude.Text.Trim()) + "',Longitude='" + Util.GetString(txtLongitude.Text.Trim()) + "' WHERE CentreID =" + Util.GetInt(ViewState["CenterMasterID"].ToString()) + " ";

            //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, SQL);
            string nablfilename = string.Empty;
            if (flIsNabl.HasFile)
                nablfilename = UploadImage(flIsNabl);
            string iscapfilename = string.Empty;
            if (flIsCap.HasFile)
                iscapfilename = UploadImage(flIsCap);
            string centerlogo = string.Empty;
            if (HeaderLogoCrystalReport.HasFile)
                centerlogo = UploadImage(HeaderLogoCrystalReport);
            string footerlogo = string.Empty;
            if (footerLogoCrystalReport.HasFile)
                footerlogo = UploadImage(footerLogoCrystalReport);
            StringBuilder sb = new StringBuilder();
            sb.Append("update center_master set CentreCode='" + txtccode.Text.Trim() + "',CentreName='" + txtCName.Text.Trim() + "',Website='" + txtWebsite.Text.Trim() + "',Address='" + txtCAddress.Text.Trim() + "',MobileNo= '" + txtMobile.Text.Trim() + "',LandlineNo='" + txtLandline.Text.Trim() + "',EmailID='" + txtMail.Text.Trim() + "',IsActive= '" + rbtActive.SelectedValue + "',DiscountType='" + ddlDiscount.SelectedValue + "',UpdateDate= '" + System.DateTime.Now.ToString("yyyy-MM-dd") + "',IsDefault=" + IsDefault + ",Latitude='" + Util.GetString(txtLatitude.Text.Trim()) + "',Longitude='" + Util.GetString(txtLongitude.Text.Trim()) + "',FollowedCentreId=" + FollowedCentre + ",InitialChar='" + InitialChar + "' ");
            if (!String.IsNullOrEmpty(centerlogo))
                sb.Append(" ,ReportHeaderURL='" + centerlogo.Trim() + "' ");
            if (!String.IsNullOrEmpty(footerlogo))
                sb.Append(" ,ReportFooterURL='" + footerlogo.Trim() + "' ");
            if (!String.IsNullOrEmpty(nablfilename))
                sb.Append(" ,NablLogoPath='" + nablfilename.Trim() + "' ");
            sb.Append(" ,IsNableCentre='" + Util.getbooleanInt(Util.GetBoolean(chkIsNablCenter.Checked)) + "' ");
            if (!String.IsNullOrEmpty(iscapfilename))
                sb.Append(" ,CapLogoPath='" + iscapfilename.Trim() + "' ");
            sb.Append(" ,isCap='" + Util.getbooleanInt(Util.GetBoolean(chkIsCap.Checked)) + "' ");
            sb.Append(" ,PrePrintedBarcode='" + Util.getbooleanInt(Util.GetBoolean(chkPrePrintedBarcode.Checked)) + "' ");
            if (txtPrePrintedBarcode.Text.Trim().Length == 1 && chkPrePrintedBarcode.Checked)
                sb.Append(" ,LabBarcodeAbbreviation='" + txtPrePrintedBarcode.Text.Trim() + "' ");

            sb.Append(" ,CountryID='" + ddlCountry.SelectedItem.Value + "' , Country='" + ddlCountry.SelectedItem.Text + "' , StateID='" + ddlState.SelectedItem.Value + "' , State='" + ddlState.SelectedItem.Text + "' , DistrictID='" + ddlDistrict.SelectedItem.Value + "' , District='" + ddlDistrict.SelectedItem.Text + "' , CityID='" + ddlCity.SelectedItem.Value + "' , City='" + ddlCity.SelectedItem.Text + "' ");
          
            sb.Append(" where CentreId=" + Util.GetInt(ViewState["CenterMasterID"].ToString()) + "");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            if (ViewState["DoctorID"] != null && ViewState["DoctorID"].ToString() != "")
            {
                string DelDoctor = "DELETE FROM f_center_doctor where CentreID= '" + ViewState["CenterMasterID"].ToString() + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, DelDoctor);
                LoadCacheQuery.dropCache(string.Concat("Doctor", "_", ViewState["CenterMasterID"].ToString()));

                string[] str = ViewState["DoctorID"].ToString().Split(',');

                foreach (string s in str)
                {
                    string SqlDoctor = "INSERT INTO f_center_doctor(DoctorID,CentreID,createdBy) values('" + s + "','" + ViewState["CenterMasterID"].ToString() + "','" + Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, SqlDoctor);
                }
                ViewState["DoctorID"] = "";
            }

            if (ViewState["PanelID"] != null && ViewState["PanelID"].ToString() != "")
            {
                string DelPanel = "DELETE FROM f_center_panel where CentreID= '" + ViewState["CenterMasterID"].ToString() + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, DelPanel);

                LoadCacheQuery.dropCache(string.Concat("PanelOPD", "_", ViewState["CenterMasterID"].ToString()));
                LoadCacheQuery.dropCache(string.Concat("PanelIPD", "_", ViewState["CenterMasterID"].ToString()));

                string[] str = ViewState["PanelID"].ToString().Split(',');

                foreach (string s in str)
                {
                    string SqlPanel = "INSERT INTO f_center_panel(PanelID,CentreID,createdBy) values(" + s + ",'" + ViewState["CenterMasterID"].ToString() + "','" + Session["ID"].ToString() + "')";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, SqlPanel);
                }

                ViewState["PanelID"] = "";
            }
            tnx.Commit();
            //UploadCenterHeaderImage(ViewState["CenterMasterID"].ToString());
            //UploadCenterFooterImage(ViewState["CenterMasterID"].ToString());
            fillGrid();

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UniqueKey2", "modelAlert('Record Updated Successfully')", true);

            divaddmaster.Attributes.Add("style", "display:none");
            lblMsg.Text = "Record Updated Successfully";
            reset();
            btnSave.Visible = true;
            btnUpdate.Visible = false;
            rbtActive.Visible = false;
            ViewState["CenterMasterID"] = "";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void Filldata(string Param)
    {
        string Sql = "";

        if (Param.ToUpper() == "D")
        {
            Sql += "SELECT Name,DoctorID ID,IF(DoctorID IS NULL,'true','false')isChecked FROM  doctor_master WHERE IsActive=1";
        }

        if (Param.ToUpper() == "P")
        {
            Sql += "SELECT Company_Name Name,PanelID ID,IF(PanelID IS NULL,'true','false')isChecked FROM f_Panel_master WHERE IsActive=1";
        }

        if (Param.ToString() == "EditDoctor")
        {
            Sql += "SELECT dm.Name,dm.DoctorID ID,IF(cd.DoctorID IS NOT NULL AND cd.CentreID ='" + ViewState["CenterMasterID"].ToString() + "','true','false')ischecked FROM  doctor_master dm LEFT JOIN f_center_doctor cd  ON dm.DoctorID=cd.DoctorID AND cd.CentreID='" + ViewState["CenterMasterID"].ToString() + "' WHERE dm.IsActive=1";
        }
        if (Param.ToString() == "EditPanel")
        {
            Sql += "SELECT pm.Company_Name Name,pm.PanelID ID,IF(cp.PanelID IS NOT NULL AND cp.CentreID ='" + ViewState["CenterMasterID"].ToString() + "','true','false')ischecked FROM f_Panel_master pm LEFT JOIN f_center_panel cp  ON pm.PanelID=cp.PanelID AND cp.CentreID='" + ViewState["CenterMasterID"].ToString() + "' WHERE pm.IsActive=1";
        }
        dt = StockReports.GetDataTable(Sql);
        if (dt != null && dt.Rows.Count > 0)
        {
            grdOption.DataSource = dt;
            grdOption.DataBind();
        }
    }

    protected void fillGrid()
    {
        string SQL = "SELECT IFNULL(c.CentreName,'') FollowedCentre,cm.FollowedCentreId,cm.InitialChar, cm.Latitude, cm.Longitude, cm.CentreID, cm.CentreName, cm.CentreCode, cm.Website, Concat(IFNULL(cm.Address,''),',',cm.City,',',cm.District,',',cm.State,',',cm.Country) AS Address, cm.MobileNo, cm.LandlineNo, cm.EmailID, cm.DiscountType, cm.IsActive,cm.NablLogoPath,cm.IsNableCentre,cm.CapLogoPath,cm.isCap,cm.LabBarcodeAbbreviation,cm.PrePrintedBarcode FROM center_master cm LEFT join center_master c on c.CentreID=cm.FollowedCentreId ";
        dt = StockReports.GetDataTable(SQL);
        if (dt.Rows.Count > 0)
        {
            grvCentre.DataSource = dt;
            grvCentre.DataBind();
        }
    }

    protected void grvCentre_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (e.CommandName == "imbRemove")
            {
                int args = Util.GetInt(e.CommandArgument);

                string DelCenter = "Update center_master set IsActive=0 where CentreID= '" + args + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, DelCenter);

                tnx.Commit();
                fillGrid();
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grvCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            int CentreID = Convert.ToInt32(grvCentre.DataKeys[grvCentre.SelectedIndex].Value);
            lblselectedcenterid.Text = CentreID.ToString();
            ViewState["CenterMasterID"] = CentreID.ToString();
            string sql = "select FollowedCentreId,InitialChar,Latitude,Longitude,CentreCode,CentreName,Website,Address,MobileNo,LandlineNo,EmailID,DiscountType,IsDefault,IsActive,NablLogoPath,IsNableCentre,CapLogoPath,isCap,LabBarcodeAbbreviation,PrePrintedBarcode,CountryID,StateID,DistrictID,CityID from center_master where CentreID =" + CentreID;
            dt = StockReports.GetDataTable(sql);
            if (dt.Rows.Count > 0)
            {
                txtccode.Text = dt.Rows[0]["CentreCode"].ToString();
                txtCName.Text = dt.Rows[0]["CentreName"].ToString();
                txtWebsite.Text = dt.Rows[0]["Website"].ToString();
                txtCAddress.Text = dt.Rows[0]["Address"].ToString();
                txtMobile.Text = dt.Rows[0]["MobileNo"].ToString();
                txtLandline.Text = dt.Rows[0]["LandlineNo"].ToString();
                txtMail.Text = dt.Rows[0]["EmailID"].ToString();
                txtLongitude.Text = dt.Rows[0]["Longitude"].ToString();
                txtLatitude.Text = dt.Rows[0]["Latitude"].ToString();
                //  lblActive.Visible = true;
                rbtActive.Visible = true;
                btnSave.Visible = false;
                btnUpdate.Visible = true;
                lblMsg.Text = "";
                txtInitialChar.Text = dt.Rows[0]["InitialChar"].ToString();
                ddlFollowedCentre.SelectedIndex = ddlFollowedCentre.Items.IndexOf(ddlFollowedCentre.Items.FindByValue(dt.Rows[0]["FollowedCentreId"].ToString()));

                ddlDiscount.SelectedIndex = ddlDiscount.Items.IndexOf(ddlDiscount.Items.FindByText(dt.Rows[0]["DiscountType"].ToString()));


                ddlCountry.SelectedIndex = ddlCountry.Items.IndexOf(ddlCountry.Items.FindByValue(dt.Rows[0]["CountryID"].ToString()));
                BindState();
                ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(dt.Rows[0]["StateID"].ToString()));
                BindDistrict();
                ddlDistrict.SelectedIndex = ddlDistrict.Items.IndexOf(ddlDistrict.Items.FindByValue(dt.Rows[0]["DistrictID"].ToString()));
                BindCity();
                ddlCity.SelectedIndex = ddlCity.Items.IndexOf(ddlCity.Items.FindByValue(dt.Rows[0]["CityID"].ToString()));

                if (dt.Rows[0]["FollowedCentreId"].ToString() == CentreID.ToString())
                {
                    chkSelf.Checked = true;
                    txtInitialChar.Style.Remove("display");
                    ddlFollowedCentre.Style.Add("display", "none");
                    lblInitialCharCap.Text = "Prefix";
                }
                else
                {
                    chkSelf.Checked = false;
                    txtInitialChar.Style.Add("display", "none");
                    ddlFollowedCentre.Style.Remove("display");
                    lblInitialCharCap.Text = "Centre";
                }
                if (dt.Rows[0]["IsNableCentre"].ToString() == "1")
                    chkIsNablCenter.Checked = true;
                else
                    chkIsNablCenter.Checked = false;
                if (dt.Rows[0]["isCap"].ToString() == "1")
                    chkIsCap.Checked = true;
                else
                    chkIsCap.Checked = false;
                txtPrePrintedBarcode.Text = dt.Rows[0]["LabBarcodeAbbreviation"].ToString();
                if (dt.Rows[0]["PrePrintedBarcode"].ToString() == "1")
                    chkPrePrintedBarcode.Checked = true;
                else
                    chkPrePrintedBarcode.Checked = false;

                if (dt.Rows[0]["IsActive"].ToString() == "1")
                    rbtActive.SelectedIndex = 0;
                else
                    rbtActive.SelectedIndex = 1;
                divaddmaster.Attributes.Add("style", "display:block");
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fillGrid();
            BindCentre();
            BindCountry();
            BindState();
            BindDistrict();
            BindCity();
            string DoctorID = "", PanelID = "", ItemID = "";
            ViewState["DoctorID"] = DoctorID;
            ViewState["PanelID"] = PanelID;
            ViewState["ItemID"] = ItemID;
            ViewState["IsUpdate"] = "0";
            ViewState["CenterMasterID"] = "";
            if (Resources.Resource.ApplicationRunCentreWise == "0")
            {
                lblMsg.Text = "Application Only One Centre,So Mapping not Required";
                btnSave.Enabled = false;
                btnUpdate.Enabled = false;
            }
        }
    }

    protected void reset()
    {
        txtccode.Text = "";
        txtCName.Text = "";
        txtWebsite.Text = "";
        txtCAddress.Text = "";
        txtMobile.Text = "";
        txtLandline.Text = "";
        txtMail.Text = "";
        ddlDiscount.SelectedIndex = -1;
        chkPrePrintedBarcode.Checked = false;
        chkIsCap.Checked = false;
        chkIsNablCenter.Checked = false;
        txtPrePrintedBarcode.Text = "";
    }
    protected void ddlCountry_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        BindState();
        BindDistrict();
        BindCity();
    }
    protected void ddlState_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        BindDistrict();
        BindCity();
    }
    protected void ddlDistrict_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        BindCity();
    }
}