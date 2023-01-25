using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Odbc;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using MySql.Data.MySqlClient;
public partial class Design_OPD_MemberShipCard_MembershipCard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            btnSave.Visible = false;
            ViewState["ID"] ="0";
            ViewState["LoginType"] = Session["LoginType"].ToString();
            BindCardMember();
            txtValidFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            {
                ddlMembershipCard_SelectedIndexChanged(sender, e);
            }
            bindTitle();
            txtValidFromDate.Attributes.Add("onKeyPress", "AddDate()");
            if (ViewState["LoginType"].ToString() == "EDP")
            {
                btnSearch.Visible = true;
                txtValidFromDate.ReadOnly = false;
                txtValidToDate.ReadOnly = false;
            }
            if (Request.QueryString["PatientID"] != null && Request.QueryString["ReceiptNo"] != null)
            {
                ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
                ViewState["ReceiptNo"] = Request.QueryString["ReceiptNo"].ToString();
                txtPID.Text = ViewState["PatientID"].ToString();
                BindPatientDetailandReceipt();
            }
        }

        txtValidFromDate.Attributes.Add("readOnly", "readOnly");
        txtValidToDate.Attributes.Add("readOnly", "readOnly");
    }
    #region BindData


    protected void BindCardMember()
    {
        DataTable dt = StockReports.GetDataTable("SELECT CONCAT(mcm.ID,'#',mcm.No_of_dependant,'#',mcm.CardValid,'#',IFNULL(rt.Rate,0))ID,NAME FROM  membership_card_master mcm INNER JOIN f_itemmaster im ON im.ItemID=mcm.ItemID LEFT JOIN f_ratelist rt ON rt.itemID=im.ItemID AND rt.IsCurrent=1 AND rt.PanelID=1 WHERE mcm.IsActive=1 AND im.IsActive=1 ");
        if (dt.Rows.Count > 0)
        {
            ddlMembershipCard.DataSource = dt;
            ddlMembershipCard.DataTextField = "NAME";
            ddlMembershipCard.DataValueField = "ID";
            ddlMembershipCard.DataBind();
            ddlMembershipCard.SelectedIndex = 0;

        }
    }
    protected void BindFamilyDetail(int No_of_Dependant)
    {
        DataTable dt = new DataTable();
        //dt.Columns.Add(new DataColumn("ID"));

        for (int i = 1; i < No_of_Dependant; i++)
        {
            DataRow row = dt.NewRow();
            dt.Rows.Add(row);
        }
        MemberFamilyDetail.DataSource = dt;
        MemberFamilyDetail.DataBind();
    }
    #endregion

    #region Save MemberDetail


    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (ValidateData())
        {

            lblmsg.Text = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                //Save in membershipcard


                string Query = " INSERT INTO membershipcard(CardNo,NAME,Age,Gender,Address,Phone,Mobile,Email,MembershipCardID,MembershipCardName,ValidFrom,ValidTo,ReceiptNo,UserID,Amount,STATUS,Source,SourceName,ReferedBy,ReferedByName)VALUES ('" + txtCardNo.Text.Trim().Replace("'", "") + "','" + txtName.Text.Trim().Replace("'", "") + "','" + txtAge.Text + "','" + ddlGender.SelectedItem.Value + "','" + txtAddress.Text.Trim().Replace("'", "") + "','" + txtPhone.Text.Replace("'", "") + "','" + txtMobile.Text.Replace("'", "") + "','" + txtEmail.Text.Replace("'", "") + "'," + ddlMembershipCard.SelectedItem.Value.Split('#')[0] + ",'" + ddlMembershipCard.SelectedItem.Text + "','" + Util.GetDateTime(txtValidFromDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtValidToDate.Text).ToString("yyyy-MM-dd") + "','" + txtreceiptno.Text.Trim() + "','" + ViewState["ID"].ToString() + "'," + lblAmount.Text.Trim() + ",'" + ddlStatus.SelectedValue + "','" + ddlSource.SelectedValue + "','" + txtSourceName.Text.Trim() + "','" + ddlReferedBy.SelectedValue + "','" + txtReferedByname.Text.Trim() + "');";
                string PhotoID = string.Empty;
                string PhotoID2 = string.Empty;
                string MemberAge = txtAge.Text.Trim() + " " + ddlMemberAge.SelectedItem.Value;
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                //Save in membershipcard_member Self Entry
                PhotoID = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(PhotoUploader.FileName));
                PhotoID2 = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(PhotoUploader.FileName));
                string PhotoUrl = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
                string PhotoUrl2 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID2 + "");
                if (!PhotoUploader.HasFile)
                {
                    PhotoUrl2 = "";
                    PhotoUrl = "";
                }
                Query = "INSERT INTO membershipcard_member(CardNo,Title,NAME,Age,Gender,Relation,Photo,UserID)	VALUES('" + txtCardNo.Text.Trim().Replace("'", "") + "','" + cmbTitle.SelectedItem.Text + "','" + txtName.Text.Trim() + "', '" + MemberAge + "','" + ddlGender.SelectedItem.Text + "',	'SELF', '" + PhotoID2 + "','0');";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                if (PhotoUploader.HasFile)
                {
                    PhotoUploader.SaveAs(PhotoUrl);
                    //string url = PhotoUploader.PostedFile.FileName.Replace("/", @"\");
                    string url = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");


                    Bitmap originalImage = new Bitmap(url);
                    Size NewSize = new Size(120, 120);
                    Bitmap NewImage = new Bitmap(originalImage, NewSize);

                    NewImage.Save(PhotoUrl2, ImageFormat.Jpeg);

                    //Dispose Object
                    originalImage.Dispose();
                    NewImage.Dispose();
                    File.Delete(PhotoUrl);
                }

                //Save in membershipcard_member CardHolder Dependant
                foreach (GridViewRow row in MemberFamilyDetail.Rows)
                {
                    string PatientID = "";
                    if (((CheckBox)row.FindControl("chk")).Checked)
                    {
                        PhotoID = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(PhotoUploader.FileName));
                        PhotoID2 = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(PhotoUploader.FileName));
                        if (((FileUpload)row.FindControl("PhotoUpload")).HasFile)
                        {
                            PhotoUrl = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
                            PhotoUrl2 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID2 + "");
                        }
                        else
                        {
                            PhotoUrl = "";
                            PhotoUrl2 = "";
                        }

                        DataTable dtMemberdetail = StockReports.GetDataTable("Select City,State,Country,District,CentreID,CountryID,DistrictID,CityID,StateID,talukaID,Taluka from patient_master where PatientID='" + lblMRNo.Text + "' ");

                        MemberAge = ((TextBox)row.FindControl("txtAge")).Text.Trim().Replace("'", "") + " " + ((DropDownList)row.FindControl("ddlAge")).SelectedItem.Value;
                        Query = "INSERT INTO membershipcard_member(CardNo,Title,NAME,Age,Gender,Relation,Photo,UserID)	VALUES('" + txtCardNo.Text.Trim().Replace("'", "") + "','" + ((DropDownList)row.FindControl("cmbTitle")).SelectedItem.Text + "','" + ((TextBox)row.FindControl("txtName")).Text.Trim().Replace("'", "") + "', '" + MemberAge + "','" + ((DropDownList)row.FindControl("ddlGender")).SelectedItem.Value + "','" + ((DropDownList)row.FindControl("ddlRelation")).SelectedItem.Value + "', '" + PhotoID2 + "','" + ViewState["ID"].ToString() + "');";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                        Patient_Master pm = new Patient_Master(Tranx);
                        pm.Title = ((DropDownList)row.FindControl("cmbTitle")).SelectedItem.Text;
                        pm.PFirstName = ((TextBox)row.FindControl("txtName")).Text.Trim().Replace("'", "");
                        pm.PName = ((TextBox)row.FindControl("txtName")).Text.Trim().Replace("'", "");
                        pm.Age = MemberAge;
                        pm.Gender = ((DropDownList)row.FindControl("ddlGender")).SelectedItem.Value;
                        pm.DateEnrolled = Util.GetDateTime(System.DateTime.Now);
                        pm.Mobile = txtMobile.Text.Trim();
                        pm.Phone = txtPhone.Text.Trim();
                        pm.City = dtMemberdetail.Rows[0]["City"].ToString();
                        pm.State = dtMemberdetail.Rows[0]["State"].ToString();
                        pm.Country = dtMemberdetail.Rows[0]["Country"].ToString();
                        pm.District = dtMemberdetail.Rows[0]["District"].ToString();
                        pm.CentreID = Util.GetInt(dtMemberdetail.Rows[0]["CentreID"].ToString());
                        pm.CountryID = Util.GetInt(dtMemberdetail.Rows[0]["CountryID"].ToString());
                        pm.DistrictID = Util.GetInt(dtMemberdetail.Rows[0]["DistrictID"].ToString());
                        pm.CityID = Util.GetInt(dtMemberdetail.Rows[0]["CityID"].ToString());
                        pm.StateID = Util.GetInt(dtMemberdetail.Rows[0]["StateID"].ToString());
                        pm.TalukaID = Util.GetInt(dtMemberdetail.Rows[0]["TalukaID"].ToString());
                        pm.Taluka = dtMemberdetail.Rows[0]["Taluka"].ToString();
                        PatientID = pm.Insert();
                        if (PatientID != "")
                        {
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update Patient_master Set membership='" + txtCardNo.Text.Trim().Replace("'", "") + "',MemberShipDate='" + Util.GetDateTime(txtValidToDate.Text).ToString("yyyy-MM-dd") + "' where PatientID='" + PatientID + "'");

                        }
                        if (((FileUpload)row.FindControl("PhotoUpload")).HasFile)
                        {
                            ((FileUpload)row.FindControl("PhotoUpload")).SaveAs(PhotoUrl);
                            ////////////Compress Image size
                            //string url1 = ((FileUpload)row.FindControl("PhotoUpload")).PostedFile.FileName.Replace("/", @"\");
                            string url1 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
                            Bitmap originalImage1 = new Bitmap(url1);
                            Size NewSize1 = new Size(120, 120);
                            Bitmap NewImage1 = new Bitmap(originalImage1, NewSize1);
                            NewImage1.Save(PhotoUrl2, ImageFormat.Jpeg);

                            //Dispose Object
                            originalImage1.Dispose();
                            NewImage1.Dispose();
                            if (File.Exists(PhotoUrl))
                            {
                                File.Delete(PhotoUrl);
                            }
                        }
                    }
                }

                if (lblMRNo.Text != "")
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update Patient_master Set membership='" + txtCardNo.Text.Trim().Replace("'", "") + "',MemberShipDate='" + Util.GetDateTime(txtValidToDate.Text).ToString("yyyy-MM-dd") + "' where PatientID='" + lblMRNo.Text + "'");
                }

                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();

                lblmsg.Text = "Record Saved Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Save", "alert('Record Saved Successfully' );", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Redirect", "location.href='MembershipCard.aspx';", true);


            }

            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return;
            }
        }
        else
        {
            btnSave.Enabled = true;
        }

    }

    #endregion

    #region Validation
    private bool ValidateData()
    {
        //string Extension = Path.GetExtension(PhotoUploader.FileName);
        //if (Extension.ToLower() != ".jpg")
        //{
        //    lblmsg.Text = "Onlye .Jpg Image Upload";
        //    return false;
        //}
        //Card No valid

        if (txtCardNo.Text.Trim().Replace("'", "") == "")
        {
            lblmsg.Text = "Please Enter Card No.";
            txtCardNo.Focus();
            return false;
        }
        if (Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM membershipcard WHERE CardNo='" + txtCardNo.Text.Trim().Replace("'", "") + "' ")) > 0)
        {
            lblmsg.Text = "Card No. Already Exist";
            txtCardNo.Focus();
            return false;
        }

        if (txtName.Text.Trim() == "")
        {
            lblmsg.Text = "Provide Patient name";
            txtName.Focus();
            return false;
        }

        if (txtAge.Text.Trim() == "")
        {
            lblmsg.Text = "Provide Patient Age";
            txtAge.Focus();
            return false;
        }

        if (txtAddress.Text.Trim() == "")
        {
            lblmsg.Text = "Provide Patient Address";
            txtAddress.Focus();
            return false;
        }

        if (txtValidFromDate.Text.Trim() == "")
        {
            lblmsg.Text = "Provide Card Valid From Date";
            txtValidFromDate.Focus();
            return false;
        }

        if (txtValidToDate.Text.Trim() == "")
        {
            lblmsg.Text = "Provide Card Valid To Date";
            txtValidToDate.Focus();
            return false;
        }

        if (txtreceiptno.Text.Trim() == "")
        {
            lblmsg.Text = "Provide Receipt No";
            txtreceiptno.Focus();
            return false;
        }
        if (Util.GetInt(StockReports.ExecuteScalar(" SELECT count(*) FROM f_reciept WHERE ReceiptNo='" + txtreceiptno.Text.Trim() + "' and Depositor='" + lblMRNo.Text.Trim() + "' ")) == 0)
        {
            lblmsg.Text = "Receipt No. is not valid. Please Enter a valid ReceiptNo. ";
            txtreceiptno.Focus();
            return false;
        }

        bool flag = true;
        foreach (GridViewRow row in MemberFamilyDetail.Rows)
        {
            if (((CheckBox)row.FindControl("chk")).Checked)
            {
                if (((TextBox)row.FindControl("txtName")).Text == "")
                {
                    lblmsg.Text = "Name Required";
                    ((TextBox)row.FindControl("txtName")).Focus();
                    flag = false;
                    return false;
                }
                if (((TextBox)row.FindControl("txtAge")).Text == "")
                {
                    lblmsg.Text = "Age Required";
                    ((TextBox)row.FindControl("txtAge")).Focus();
                    flag = false;
                    return false;
                }

                //if (((FileUpload)row.FindControl("PhotoUpload")).HasFile != true)
                //{
                //    lblmsg.Text = "Photo Required";
                //    ((FileUpload)row.FindControl("PhotoUpload")).Focus();
                //    flag = false;
                //    return false;
                //}
                //Extension = Path.GetExtension(((FileUpload)row.FindControl("PhotoUpload")).FileName);
                //if (Extension.ToLower() != ".jpg")
                //{
                //    lblmsg.Text = "Onlye .Jpg Image Upload";
                //    return false;
                //}

            }
        }
        return flag;


    }
    #endregion
    protected void ddlMembershipCard_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlMembershipCard.SelectedItem != null)
        {
            BindFamilyDetail(Util.GetInt(ddlMembershipCard.SelectedItem.Value.Split('#')[1]));
            //Set To Date
            txtValidToDate.Text = DateTime.Now.AddYears(Util.GetInt(ddlMembershipCard.SelectedItem.Value.Split('#')[2])).ToString("dd-MMM-yyyy");
            lblAmount.Text = ddlMembershipCard.SelectedItem.Value.Split('#')[3];
        }
    }



    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtCardNo.Text))
            searchPatientByMemberShipCard(sender, e);
        else
            SearchPatientByPatientID();
    }

    private void BindPatientDetailandReceipt()
    {
        SearchPatientByPatientID();
        txtreceiptno.Text = ViewState["ReceiptNo"].ToString();

        string membershipcardID = StockReports.ExecuteScalar("SELECT mm.NAME,mm.ID FROM f_reciept rt INNER JOIN f_ledgertnxdetail lt ON rt.AsainstLedgerTnxNo=lt.LedgertransactionNo INNER JOIN membership_card_master mm ON mm.ItemID = lt.ItemID WHERE ReceiptNo='" + ViewState["ReceiptNo"].ToString() + "' Limit 1");

        for (int i = 0; i < ddlMembershipCard.Items.Count; i++)
        {
            if (membershipcardID.ToString() == ddlMembershipCard.Items[i].Value.Split('#')[0])
            {

                ddlMembershipCard.SelectedIndex = i;
            }
        }

        ddlMembershipCard.Enabled = false;
        ddlMembershipCard.Font.Bold = true;
        txtName.Enabled=false;
        txtAddress.Enabled=false;
        txtAge.Enabled = false;
        ddlMemberAge.Enabled = false;
        txtEmail.Enabled = false;
        txtMobile.Enabled = false;
        txtPhone.Enabled = false;
        txtreceiptno.Enabled = false;
        txtValidFromDate.Enabled = false;
        txtValidToDate.Enabled = false;
        ddlGender.Enabled = false;

        txtReferedByname.Enabled = false;
        txtSourceName.Enabled = false;
        ddlStatus.Enabled = false;
        ddlSource.Enabled = false;
        ddlReferedBy.Enabled = false;
      
    }

    private void SearchPatientByPatientID()
    {
        if (txtPID.Text.Trim() != "")
        {
            DataTable dt = new DataTable();
            dt = GetPatientByPID(txtPID.Text.Trim());

            if (dt != null && dt.Rows.Count > 0)
            {
                BindPatient(dt);
                btnSave.Visible = true;
            }
        }
        else
        {
            lblmsg.Text = "Details not Found";
            btnSave.Visible = false;
            return;
        }
    }

    private void searchPatientByMemberShipCard(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        string Age = "";
        DataTable dt = StockReports.GetDataTable(" SELECT mcm.ID,mc.CardNo,mc.Address,mc.Phone,mc.Phone,mc.Mobile,mc.Email,mc.MembershipCardID,mc.MembershipCardName,ValidFrom,ValidTo,Amount,ReceiptNo,mcm.Title,mcm.Name,mcm.Age,mcm.Gender,mcm.Relation,mcm.Photo,STATUS,Source,SourceName,ReferedBy,ReferedByName FROM membershipcard mc INNER JOIN membershipcard_member mcm ON mc.CardNo=mcm.CardNo WHERE mc.CardNo='" + txtCardNo.Text.Trim() + "' order by mcm.ID ");
        if (dt.Rows.Count > 0)
        {
            ddlMembershipCard.Enabled = false;
            ddlMembershipCard.Font.Bold = true;
            DataRow[] rows = dt.Select("Relation='SELF'");

            txtName.Text = rows[0]["Name"].ToString();
            txtAddress.Text = dt.Rows[0]["Address"].ToString();
            Age = txtAge.Text = dt.Rows[0]["Age"].ToString();
            txtAge.Text = Age.Split(' ')[0].ToString();
            ddlMemberAge.SelectedIndex = ddlMemberAge.Items.IndexOf(ddlMemberAge.Items.FindByValue(Age.Split(' ')[1].ToString()));
            txtEmail.Text = dt.Rows[0]["Email"].ToString();
            txtMobile.Text = dt.Rows[0]["Mobile"].ToString();
            txtPhone.Text = dt.Rows[0]["Phone"].ToString();
            txtreceiptno.Text = dt.Rows[0]["ReceiptNo"].ToString();
            txtValidFromDate.Text = Util.GetDateTime(dt.Rows[0]["ValidFrom"].ToString()).ToString("dd-MMM-yyyy");
            txtValidToDate.Text = Util.GetDateTime(dt.Rows[0]["ValidTo"].ToString()).ToString("dd-MMM-yyyy");
            ddlGender.SelectedIndex = ddlGender.Items.IndexOf(ddlGender.Items.FindByValue(dt.Rows[0]["Gender"].ToString()));

            txtReferedByname.Text = dt.Rows[0]["ReferedByName"].ToString();
            txtSourceName.Text = dt.Rows[0]["SourceName"].ToString();
            ddlStatus.SelectedIndex = ddlStatus.Items.IndexOf(ddlStatus.Items.FindByValue(dt.Rows[0]["STATUS"].ToString()));
            ddlSource.SelectedIndex = ddlSource.Items.IndexOf(ddlSource.Items.FindByValue(dt.Rows[0]["Source"].ToString()));
            ddlReferedBy.SelectedIndex = ddlReferedBy.Items.IndexOf(ddlReferedBy.Items.FindByValue(dt.Rows[0]["ReferedBy"].ToString()));
            lblSelfID.Text = dt.Rows[0]["ID"].ToString();

            string Imageurl = "~/Design/OPD/MemberShipCard/Photo/" + dt.Rows[0]["Photo"].ToString();
            imgMain.ImageUrl = Imageurl;
            if (!File.Exists(Imageurl))
            {
                imgMain.ImageUrl = "~/Images/no-avatar.gif";
            };



            imgMain.Visible = true;
            for (int i = 0; i < ddlMembershipCard.Items.Count; i++)
            {
                if (dt.Rows[0]["MembershipCardID"].ToString() == ddlMembershipCard.Items[i].Value.Split('#')[0])
                {

                    ddlMembershipCard.SelectedIndex = i;
                }
            }

            ddlMembershipCard_SelectedIndexChanged(sender, e);
            foreach (GridViewRow row in MemberFamilyDetail.Rows)
            {
                ((CheckBox)row.FindControl("chk")).Checked = false;
            }

            DataRow[] row2 = dt.Select("Relation<>'SELF'", "ID ASC");
            if (row2.Length > 0)
            {
                for (int i = 0; i < row2.Length; i++)
                {
                    Age = txtAge.Text = row2[i]["Age"].ToString();
                    ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("cmbTitle")).SelectedIndex = ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("cmbTitle")).Items.IndexOf(((DropDownList)MemberFamilyDetail.Rows[i].FindControl("cmbTitle")).Items.FindByValue(row2[i]["Title"].ToString()));
                    ((CheckBox)MemberFamilyDetail.Rows[i].FindControl("chk")).Checked = true;
                    ((TextBox)MemberFamilyDetail.Rows[i].FindControl("txtName")).Text = row2[i]["Name"].ToString();
                    ((TextBox)MemberFamilyDetail.Rows[i].FindControl("txtAge")).Text = Age.Split(' ')[0].ToString();
                    ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlAge")).SelectedIndex = ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlAge")).Items.IndexOf(((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlAge")).Items.FindByValue(Age.Split(' ')[1].ToString()));
                    ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlGender")).SelectedIndex = ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlGender")).Items.IndexOf(((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlGender")).Items.FindByValue(row2[i]["Gender"].ToString()));
                    ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlRelation")).SelectedIndex = ((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlRelation")).Items.IndexOf(((DropDownList)MemberFamilyDetail.Rows[i].FindControl("ddlRelation")).Items.FindByValue(row2[i]["Relation"].ToString()));
                    Imageurl = "~/Design/OPD/MemberShipCard/Photo/" + row2[i]["Photo"].ToString();
                    if (!File.Exists(Imageurl)) {
                        Imageurl = "~/Images/no-avatar.gif";
                    };
                    ((System.Web.UI.WebControls.Image)MemberFamilyDetail.Rows[i].FindControl("img")).ImageUrl = Imageurl;
                    ((System.Web.UI.WebControls.Image)MemberFamilyDetail.Rows[i].FindControl("img")).Visible = true;
                    ((Label)MemberFamilyDetail.Rows[i].FindControl("lblID")).Text = row2[i]["ID"].ToString();


                }
            }
            btnSave.Visible = false;
            btnUpdate.Visible = true;
            btnCancel.Visible = true;
        }
        else
        {
            lblmsg.Text = "No Record Found";
        }
    }
    private void bindTitle()
    {
        cmbTitle.DataSource = AllGlobalFunction.NameTitle;
        cmbTitle.DataBind();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            //Update in membershipcard
            string Query = " update membershipcard set NAME='" + txtName.Text.Trim() + "',Age='" + txtAge.Text + "',Gender='" + ddlGender.SelectedItem.Value + "',Address='" + txtAddress.Text.Trim() + "',Phone='" + txtPhone.Text.Trim() + "',Mobile='" + txtMobile.Text.Trim() + "',Email='" + txtEmail.Text.Trim() + "',MembershipCardID='" + ddlMembershipCard.SelectedItem.Value.Split('#')[0] + "',MembershipCardName='" + ddlMembershipCard.SelectedItem.Text + "',ValidFrom='" + Util.GetDateTime(txtValidFromDate.Text).ToString("yyyy-MM-dd") + "',ValidTo='" + Util.GetDateTime(txtValidToDate.Text).ToString("yyyy-MM-dd") + "',ReceiptNo='" + txtreceiptno.Text.Trim() + "',UserID='0',Amount='" + lblAmount.Text.Trim() + "',STATUS='" + ddlStatus.SelectedValue + "',Source='" + ddlSource.SelectedValue + "',SourceName='" + txtSourceName.Text.Trim() + "',ReferedBy='" + ddlReferedBy.SelectedValue + "',ReferedByName='" + txtReferedByname.Text.Trim() + "' where CardNo='" + txtCardNo.Text.Trim() + "'";

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            //Save in membershipcard_member Self Entry
            string PhotoID = string.Empty;
            string PhotoID2 = string.Empty;
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            //Save in membershipcard_member Self Entry
            PhotoID = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(PhotoUploader.FileName));
            PhotoID2 = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(PhotoUploader.FileName));
            string PhotoUrl = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
            string PhotoUrl2 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID2 + "");
            if (!PhotoUploader.HasFile)
            {
                PhotoUrl2 = "";
                PhotoUrl = "";
            }

            string MemberAge = txtAge.Text.Trim() + " " + ddlMemberAge.SelectedItem.Value;

            Query = "update  membershipcard_member set Title='" + cmbTitle.SelectedItem.Value + "',NAME='" + txtName.Text.Trim() + "',Age='" + MemberAge + "',Gender='" + ddlGender.SelectedItem.Text + "',UserID='0' where ID='" + lblSelfID.Text.Trim() + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            if (PhotoUploader.HasFile)
            {
                //Delete OLD Image
                if (File.Exists(Server.MapPath(imgMain.ImageUrl)))
                {
                    File.Delete(Server.MapPath(imgMain.ImageUrl));
                }
                Query = "update  membershipcard_member set Photo='" + PhotoID2 + "' where ID='" + lblSelfID.Text.Trim() + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);

                PhotoUploader.SaveAs(PhotoUrl);
                //string url = PhotoUploader.PostedFile.FileName.Replace("/", @"\");
                string url = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");


                Bitmap originalImage = new Bitmap(url);
                Size NewSize = new Size(120, 120);
                Bitmap NewImage = new Bitmap(originalImage, NewSize);

                NewImage.Save(PhotoUrl2, ImageFormat.Jpeg);

                //Dispose Object
                originalImage.Dispose();
                NewImage.Dispose();
                File.Delete(PhotoUrl);
            }

            //Save in membershipcard_member CardHolder Dependant
            foreach (GridViewRow row in MemberFamilyDetail.Rows)
            {
                if (((CheckBox)row.FindControl("chk")).Checked)
                {
                    ///Insert new member
                    if (((Label)row.FindControl("lblID")).Text.Trim() == "")
                    {
                        PhotoID = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(((FileUpload)row.FindControl("PhotoUpload")).FileName));
                        PhotoID2 = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(((FileUpload)row.FindControl("PhotoUpload")).FileName));
                        if (((FileUpload)row.FindControl("PhotoUpload")).HasFile)
                        {
                            PhotoUrl = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
                            PhotoUrl2 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID2 + "");
                        }
                        else
                        {
                            PhotoUrl = "";
                            PhotoUrl2 = "";
                        }


                        MemberAge = ((TextBox)row.FindControl("txtAge")).Text.Trim().Replace("'", "") + " " + ((DropDownList)row.FindControl("ddlAge")).SelectedItem.Value;

                        Query = "INSERT INTO membershipcard_member(CardNo,Title,NAME,Age,Gender,Relation,Photo,UserID)	VALUES('" + txtCardNo.Text.Trim().Replace("'", "") + "','" + ((DropDownList)row.FindControl("cmbTitle")).SelectedItem.Text + "','" + ((TextBox)row.FindControl("txtName")).Text.Trim().Replace("'", "") + "', '" + MemberAge + "','" + ((DropDownList)row.FindControl("ddlGender")).SelectedItem.Value + "','" + ((DropDownList)row.FindControl("ddlRelation")).SelectedItem.Value + "', '" + PhotoID2 + "','" + ViewState["ID"].ToString() + "');";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                        if (((FileUpload)row.FindControl("PhotoUpload")).HasFile)
                        {
                            ((FileUpload)row.FindControl("PhotoUpload")).SaveAs(PhotoUrl);
                            ////////////Compress Image size
                            //string url1 = ((FileUpload)row.FindControl("PhotoUpload")).PostedFile.FileName.Replace("/", @"\");
                            string url1 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
                            Bitmap originalImage1 = new Bitmap(url1);
                            Size NewSize1 = new Size(120, 120);
                            Bitmap NewImage1 = new Bitmap(originalImage1, NewSize1);
                            NewImage1.Save(PhotoUrl2, ImageFormat.Jpeg);

                            //Dispose Object
                            originalImage1.Dispose();
                            NewImage1.Dispose();
                            if (File.Exists(PhotoUrl))
                            {
                                File.Delete(PhotoUrl);
                            }
                        }
                    }
                    else
                    {
                        PhotoID = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(((FileUpload)row.FindControl("PhotoUpload")).FileName));
                        PhotoID2 = Guid.NewGuid().ToString() + Path.GetExtension(Server.MapPath(((FileUpload)row.FindControl("PhotoUpload")).FileName));
                        if (((FileUpload)row.FindControl("PhotoUpload")).HasFile)
                        {
                            PhotoUrl = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
                            PhotoUrl2 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID2 + "");

                            //Delete OLD Image
                            if (File.Exists(Server.MapPath(((System.Web.UI.WebControls.Image)row.FindControl("img")).ImageUrl)))
                            {
                                File.Delete(Server.MapPath(((System.Web.UI.WebControls.Image)row.FindControl("img")).ImageUrl));


                            }


                            Query = "update  membershipcard_member set Photo='" + PhotoID2 + "' where ID='" + ((Label)row.FindControl("lblID")).Text.Trim() + "'";
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                        }
                        else
                        {
                            PhotoUrl = "";
                            PhotoUrl2 = "";
                        }


                        MemberAge = ((TextBox)row.FindControl("txtAge")).Text.Trim().Replace("'", "") + " " + ((DropDownList)row.FindControl("ddlAge")).SelectedItem.Value;
                        Query = "update  membershipcard_member set Title='" + ((DropDownList)row.FindControl("cmbTitle")).SelectedItem.Text + "',NAME='" + ((TextBox)row.FindControl("txtName")).Text.Trim().Replace("'", "") + "',Age='" + MemberAge + "',Gender='" + ((DropDownList)row.FindControl("ddlGender")).SelectedItem.Value + "',UserID='0',Relation='" + ((DropDownList)row.FindControl("ddlRelation")).SelectedItem.Value + "' where ID='" + ((Label)row.FindControl("lblID")).Text.Trim() + "'";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                        if (((FileUpload)row.FindControl("PhotoUpload")).HasFile)
                        {
                            ((FileUpload)row.FindControl("PhotoUpload")).SaveAs(PhotoUrl);
                            ////////////Compress Image size
                            //string url1 = ((FileUpload)row.FindControl("PhotoUpload")).PostedFile.FileName.Replace("/", @"\");
                            string url1 = Server.MapPath("~/Design/OPD/MemberShipCard/Photo/" + PhotoID + "");
                            Bitmap originalImage1 = new Bitmap(url1);
                            Size NewSize1 = new Size(120, 120);
                            Bitmap NewImage1 = new Bitmap(originalImage1, NewSize1);
                            NewImage1.Save(PhotoUrl2, ImageFormat.Jpeg);

                            //Dispose Object
                            originalImage1.Dispose();
                            NewImage1.Dispose();
                            if (File.Exists(PhotoUrl))
                            {
                                File.Delete(PhotoUrl);
                            }
                        }
                    }
                }
            }


            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();

            lblmsg.Text = "Record Updated Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Save", "alert('Record Updated Successfully');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Redirect", "location.href='MembershipCard.aspx';", true);


        }

        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return;
        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Redirect", "location.href='MembershipCard.aspx';", true);
    }
    protected void MemberFamilyDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex >= 0)
        {
            ((DropDownList)e.Row.FindControl("cmbTitle")).DataSource = AllGlobalFunction.NameTitle;
            ((DropDownList)e.Row.FindControl("cmbTitle")).DataBind();
            ((DropDownList)e.Row.FindControl("ddlRelation")).DataSource = AllGlobalFunction.KinRelation;
            ((DropDownList)e.Row.FindControl("ddlRelation")).DataBind();
        }
    }
    protected void btnPIDSearch_Click(object sender, EventArgs e)
    {
        if (txtPID.Text.Trim() != "")
        {
            DataTable dt = new DataTable();
            dt = GetPatientByPID(txtPID.Text.Trim());

            if (dt != null && dt.Rows.Count > 0)
            {
                BindPatient(dt);
                btnSave.Visible = true;
            }
        }
        else
        {
            lblmsg.Text = "Details not Found";
            btnSave.Visible = false;
            return;
        }
    }

    private DataTable GetPatientByPID(string PatientID)
    {
        //string str = "SELECT  pm.Title,pm.PName name,pm.PatientID,pm.StaffID,IF(DOB !='0001-01-01',DOB,'')DOB,Get_Current_Age(pm.PatientID)Age,pm.Gender,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y') AS DATE,pm.House_No,pm.phone,pm.Mobile,pm.Relation,pm.RelationName,pm.City,pm.StaffID,pm.StaffDependantID,'' StaffName,'' StaffDependantName,pm.locality, pmh.DoctorID,pmh.PanelID  FROM patient_master pm INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID WHERE pm.PatientID ='" + PatientID + "' GROUP BY  pmh.PatientID ORDER BY MAX(pmh.TransactionID )";
        string str = "SELECT  pm.Title,pm.PName name,pm.PatientID,pm.StaffID,IF(DOB !='0001-01-01',DOB,'')DOB,pm.Age,pm.Gender,DATE_FORMAT(pm.DateEnrolled,'%d-%b-%Y') AS DATE,pm.House_No,pm.phone,pm.Mobile,pm.Relation,pm.RelationName,pm.City,pm.StaffID,pm.StaffDependantID,'' StaffName,'' StaffDependantName,pm.locality, pmh.DoctorID,pmh.PanelID  FROM patient_master pm INNER JOIN patient_medical_history pmh ON pm.PatientID=pmh.PatientID WHERE pm.PatientID ='" + PatientID + "' GROUP BY  pmh.PatientID ORDER BY MAX(pmh.TransactionID )";

        DataTable dt = StockReports.GetDataTable(str);
        return dt;

    }

    private void BindPatient(DataTable dtnew)
    {

        DataTable dt = dtnew.Copy();

        cmbTitle.SelectedIndex = cmbTitle.Items.IndexOf(cmbTitle.Items.FindByText(dt.Rows[0]["Title"].ToString()));
        txtName.Text = dt.Rows[0]["name"].ToString();
        txtAddress.Text = dt.Rows[0]["House_No"].ToString() + " " + dt.Rows[0]["City"].ToString() + " ";
        lblMRNo.Text = dt.Rows[0]["PatientID"].ToString();
        txtPhone.Text = dt.Rows[0]["phone"].ToString();
        txtMobile.Text = dt.Rows[0]["Mobile"].ToString();

        txtAge.Text = dt.Rows[0]["Age"].ToString().Replace("YRS", "").Replace("DAYS(S)","");


        if (Util.GetString(dt.Rows[0]["Gender"].ToString().ToUpper()) == "MALE")
        {
            ddlGender.SelectedIndex = ddlGender.Items.IndexOf(ddlGender.Items.FindByValue("0"));
        }
        else
        {
            ddlGender.SelectedIndex = ddlGender.Items.IndexOf(ddlGender.Items.FindByValue("1"));
        }
    }
}
