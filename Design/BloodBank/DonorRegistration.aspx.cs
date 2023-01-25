using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text ;
using System.Web;
using System.Web.Services;


public partial class Design_BloodBank_DonorRegistration : System.Web.UI.Page
{
    
    protected void BindCity()
    {
        

        DataTable dt = All_LoadData.BindCity("1","1");
      //  DataView dv = dat
        ddlCity.DataSource = dt;
        ddlCity.DataTextField = "City";
        ddlCity.DataValueField = "City";
        ddlCity.DataBind();
        ddlCity.Items.Insert(0, new ListItem("Select", "0"));
       // ddlCity.SelectedItem.Text = GetGlobalResourceObject("Resource", "DefaultCity").ToString();

       
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        bool isTrue = false;
        isTrue = validation();
        if (isTrue)
        {
            lblerrmsg.Text = "";
            SaveDate();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (StockReports.RestrictOPD_For_AlreadyAddmittedPatient(txtDon.Text.Trim()))
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM216','" + lblerrmsg.ClientID + "');", true);
            return;
        }

        DataTable dtnew = GetPatientByPID(txtDon.Text.Trim());
        if (dtnew.Rows.Count > 0)
            BindPatient(dtnew);
        else
        {
            lblerrmsg.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblerrmsg.ClientID + "');", true);
            //lblerrmsg.Text = " detail not found";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindcountry(ddlNationality);
            BindCity();
            BloodBank.bindBloodGroup(ddlblood);
            bindQuestions();
            lblSession.Text = Session["ID"].ToString();
            lblCentreID.Text = Util.GetString(Session["Centre"].ToString());
            ViewState["CenterID"] = Util.GetString(Session["CentreID"].ToString());
            txtName.Focus();
            BloodBank.bindBagType(ddlBagType);
            All_LoadData.BindRelation(ddlReleation);
            All_LoadData.bindTitle(cmbTitle);
            BloodBank.bindOrganisation(ddlDetail);
            BloodBank.bindType(ddlType);
            ddlType.Items.Insert(0, "Select");
            ddlType.Items[0].Value = "0";
            
            dtentry();
            caldob.StartDate = DateTime.Now.AddYears(-60);
            txtdob.Text = System.DateTime.Now.AddYears(-18).ToString("dd-MMM-yyyy");
            caldob.EndDate = DateTime.Now.AddYears(-18);

        }
        txtdob.Attributes.Add("readOnly", "true");
        txtDonorId.Attributes.Add("readOnly", "True");


    }

    protected void rdbAns_selectedIndexChanged(object sender, EventArgs e)
    {
    }

    protected void rptQuest_DataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblFlag")).Text == "1")
            {
                ((RadioButtonList)e.Row.FindControl("rdbAns")).Items[0].Selected = true;
            }
            else if (((Label)e.Row.FindControl("lblFlag")).Text == "0")
            {
                ((RadioButtonList)e.Row.FindControl("rdbAns")).Items[1].Selected = true;
            }

            string st = ((Label)e.Row.FindControl("lblGender")).Text;
            e.Row.Attributes.Add("class", st);
            if (((Label)e.Row.FindControl("lblType")).Text == "")
            {
                ((TextBox)e.Row.FindControl("txtRemarks")).Visible = false;
            }

            if (((Label)e.Row.FindControl("lblType")).Text == "t")
            {
                ((RadioButtonList)e.Row.FindControl("rdbAns")).Visible = false;
            }
            else if (((Label)e.Row.FindControl("lblType")).Text == "r")
            {
                ((TextBox)e.Row.FindControl("txtAns")).Visible = false;
            }
            else
            {
                ((TextBox)e.Row.FindControl("txtAns")).Visible = false;
                ((RadioButtonList)e.Row.FindControl("rdbAns")).Visible = false;
            }

            RadioButtonList rdb = (RadioButtonList)e.Row.FindControl("rdbAns");
            Label LBLSNO = (Label)e.Row.FindControl("lblSeq");

            rdb.Attributes.Add("onclick", "return SetColor('" + rdb.ClientID + "','" + LBLSNO.ClientID + "');");
            rdb.Attributes.Add("onload", "return SetColor('" + rdb.ClientID + "','" + LBLSNO.ClientID + "');");
        }

        e.Row.Cells[0].Attributes.Add("Style", "display:none");
        e.Row.Cells[4].Attributes.Add("Style", "display:none");
        e.Row.Cells[5].Attributes.Add("Style", "display:none");
        
    }

    protected void rptQuest_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        RadioButtonList rdb = (RadioButtonList)e.Item.FindControl("rdbAns");
        Repeater rptSubRept = (Repeater)e.Item.FindControl("rptSubRept");
        rptSubRept.DataSource = null;
        rptSubRept.DataBind();
    }

    protected void rptQuest_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            RadioButtonList rdb = (RadioButtonList)e.Item.FindControl("rdbAns");
            rdb.Attributes.Add("onclick", "return SetColor('" + rdb.ClientID + "');");
        }
    }

    protected void rptQuest_RowCommand(object Sender, GridViewCommandEventArgs e)
    {
    }

    private void BindPatient(DataTable dtnew)
    {
        DataTable dt = dtnew.Copy();
        
        ViewState["PID"] = dt.Rows[0]["Visitor_ID"].ToString();
        txtDonorId.Text = dt.Rows[0]["Visitor_ID"].ToString();

       

        cmbTitle.SelectedItem.Text = dt.Rows[0]["Title"].ToString();
        txtName.Text = dt.Rows[0]["Name"].ToString();
        if (dt.Rows[0]["Gender"].ToString().ToUpper() == "MALE")
        {
            rblSex.SelectedIndex = rblSex.Items.IndexOf(rblSex.Items.FindByValue("Male"));
        }
        else
        {
            rblSex.SelectedIndex = rblSex.Items.IndexOf(rblSex.Items.FindByValue("Female"));
        }
        txtAddress.Text = dt.Rows[0]["Address"].ToString();
        ddlNationality.SelectedIndex = ddlNationality.Items.IndexOf(ddlNationality.Items.FindByText(dt.Rows[0]["Counrty"].ToString()));
        ddlIDProof.SelectedIndex = ddlIDProof.Items.IndexOf(ddlIDProof.Items.FindByText(dt.Rows[0]["IdProof"].ToString()));

        txtIDProofNo.Value = dt.Rows[0]["IdProofNo"].ToString();
        ddlCity.Items.Clear();
        BindCity();
        ddlCity.SelectedIndex = ddlCity.Items.IndexOf(ddlCity.Items.FindByText(dt.Rows[0]["City"].ToString()));
        txtPhone.Text = dt.Rows[0]["PhoneNo"].ToString();
        ddlReleation.SelectedItem.Text = dt.Rows[0]["Relation"].ToString();
        txtKinName.Text = dt.Rows[0]["Kin_Name"].ToString();
        
    }

   
    private void bindQuestions()
    {
        rptQues.DataSource = StockReports.GetDataTable("SELECT id Question_Id, Question AS Questions,TYPE,Gender,Status,Flag FROM bb_Questions_master WHERE isActive=1");
        rptQues.DataBind();

       
    }

    private void dtentry()
    {
        lbldtentry.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
    }

    private DataTable GetPatientByPID(string Visitor_ID)
    {
        string str = "SELECT bv,IdProof,bv.IdProofNo, bv.Title,bv.Name ,bv.Visitor_ID,bv.Gender,bv.Address,bv.city,bv.phoneNo,bv.MobileNo,bv.Relation,bv.Kin_Name  FROM bb_visitors bv  WHERE bv.Visitor_ID = '" + Visitor_ID + "' ";
        DataTable dt = StockReports.GetDataTable(str);
        return dt;
    }

    private void SaveDate()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string VisitorID = "";

            if (txtDonorId.Text == "")
            {
                Visitors vs = new Visitors(tranX);
                vs.Title = cmbTitle.SelectedItem.Text;
                vs.Dfirstname = txtfirstname.Text.Trim();
                vs.Dlastname = txtlastname.Text.Trim();
                vs.Name = txtfirstname.Text.Trim() + ' ' + txtlastname.Text.Trim();
                
                vs.Gender = txtGender.Text;
                vs.Kin_Name = txtKinName.Text.Trim();
                vs.Relation = ddlReleation.SelectedItem.Text;
                vs.BloodGroup_Id = Util.GetInt(ddlblood.SelectedItem.Value);
                vs.Address = txtAddress.Text.Trim();
                vs.Country = ddlNationality.SelectedItem.Text;
                vs.City = txtcity.Text.Trim();

                if (txtdob.Text == string.Empty)
                {
                    vs.dtBirth = Util.GetString(txtAge1.Text.Trim() + ' ' + ddlAge.SelectedItem.Value);
                }
                else
                {
                    DateTime DateofBirth = Util.GetDateTime(txtdob.Text);
                    vs.DOB = Util.GetDateTime(txtdob.Text);
                    vs.dtBirth = StockReports.ExecuteScalar("Select Get_Age('" + DateofBirth.ToString("yyyy-MM-dd") + "')");
                }
                vs.PhoneNo = txtPhone.Text.Trim();
                vs.Email = txtEmail.Text.Trim();

                vs.EntryBy = lblSession.Text;
                vs.CentreID = Util.GetInt(ViewState["CenterID"]);//Util.GetInt(lblCentreID.Text);
                vs.Blood_DonateDate = Util.GetDateTime(lbldtentry.Text);
                if (rdbFit.SelectedValue == "Yes")
                {
                    vs.isFit = 1;
                }
                else
                {
                    vs.isFit = 0;
                }
               vs.IdProof= ddlIDProof.Items[ddlIDProof.SelectedIndex].Value;
               vs.IdProofNo = txtIDProofNo.Value;
            
                VisitorID = vs.Insert();
            }
            else
                VisitorID = txtDonorId.Text;

            Visitors_History vsh = new Visitors_History(tranX);

            vsh.Visitor_ID = VisitorID;
            vsh.Blood_Pressure = txtBP.Text.Trim();
            vsh.Weight = txtWeight.Text.Trim();
            vsh.Pulse = txtPulse.Text.Trim();
            vsh.GPE = txtGpe.Text.Trim();
            vsh.Height = txtHeight.Text.Trim();
            vsh.Temprature = txtTemp.Text.Trim();
            vsh.Hb = ddlHB.SelectedItem.Text;

            if (rdbFit.SelectedValue == "Yes")
            {
                vsh.isFit = 1;
            }
            else
            {
                vsh.isFit = 0;
            }
            if (ddlType.SelectedItem.Text.ToLower() == "volunteer")
            {
                vsh.donationtype = ddlType.SelectedValue;
                vsh.typedetail = ddlDetail.SelectedValue;
            }
            else if (ddlType.SelectedItem.Text.ToLower() == "a-por")
            {
                vsh.donationtype = ddlType.SelectedValue;
                vsh.typedetail = txtDetail.Text;
            }
            else if (ddlType.SelectedItem.Text.ToLower() == "replacement")
            {
                vsh.donationtype = ddlType.SelectedValue;
                vsh.typedetail = txtDetail.Text;
            }
            else
            {
                vsh.donationtype = "";
                vsh.typedetail = "";
            }
            vsh.Remarks = txtRemark.Text.Trim();
            if (ddlBagType.SelectedIndex > 0)
            {
                if (ddlBagType.SelectedItem.Value == "1")
                    vsh.Quantity = ddlQty1.SelectedItem.Text;
                else
                    vsh.Quantity = ddlQty.SelectedItem.Text;
                vsh.BagType = ddlBagType.SelectedItem.Text;
            }


            else
            {
                vsh.BagType = "";
                vsh.Quantity = "";
            }
            vsh.EntryBy = lblSession.Text;
            vsh.CentreID = Util.GetInt(ViewState["CenterID"]); //Util.GetInt(lblCentreID.Text);
            vsh.IPDNo = txtIpdNo.Text.Trim();
            vsh.Platelets = txtPlate.Text;
            vsh.isPhlebotomy = ddlPhle.SelectedItem.Text;
            if (ddlBDonate.SelectedItem.Text == "Select")
            {
                vsh.Blood_donate = "";
            }
            else
            {
                vsh.Blood_donate = ddlBDonate.SelectedItem.Text;
            }

            string VisitID = vsh.Insert();
            Visitors_Answer vsa = new Visitors_Answer(tranX);
            string dob = "";
            if (txtdob.Text == string.Empty)
            {
                dob = Util.GetString(txtAge1.Text.Trim() + ' ' + ddlAge.SelectedItem.Value);
            }
            else
            {
                DateTime DateofBirth = Util.GetDateTime(txtdob.Text);

                dob = StockReports.ExecuteScalar("Select Get_Age('" + DateofBirth.ToString("yyyy-MM-dd") + "')");
            }
            string name = txtfirstname.Text.Trim() + ' ' + txtlastname.Text.Trim();
            string collection = "UPDATE bb_visitors SET title='" + cmbTitle.SelectedItem.Text + "' ,Dfirstname='" + txtfirstname.Text.Trim() + "' ,Dlastname='" + txtlastname.Text.Trim() + "' ,Name='" + name + "' ,dtbirth='" + dob + "' ,Gender='" + txtGender.Text + "' ,kin_Name='" + txtKinName.Text.Trim() + "' ,Relation='" + ddlReleation.SelectedItem.Text + "' ,Country='" + ddlNationality.SelectedItem.Text + "' ,City='" + txtcity.Text.Trim() + "' ,Email='" + txtEmail.Text.Trim() + "' ,Phoneno='" + txtPhone.Text.Trim() + "' WHERE Visitor_id='" + VisitorID + "'";
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, collection);
            foreach (GridViewRow rpt in rptQues.Rows)
            {
                if (((Label)rpt.FindControl("lblType")).Text == "t")
                {
                    vsa.Visitor_ID = VisitorID;
                    vsa.VisitID = VisitID;
                    vsa.Question_Id = Util.GetInt(((Label)rpt.FindControl("lblQuestId")).Text);
                    vsa.Question = ((Label)rpt.FindControl("lblQues")).Text;
                    vsa.Answer = ((TextBox)rpt.FindControl("txtAns")).Text.Trim();
                    vsa.Remarks = ((TextBox)rpt.FindControl("txtRemarks")).Text.Trim();
                    vsa.Insert();
                }
                else if (((Label)rpt.FindControl("lblType")).Text == "r")
                {
                    vsa.Visitor_ID = VisitorID;
                    vsa.VisitID = VisitID;
                    vsa.Question_Id = Util.GetInt(((Label)rpt.FindControl("lblQuestId")).Text);
                    vsa.Question = ((Label)rpt.FindControl("lblQues")).Text;
                    vsa.Answer = ((RadioButtonList)rpt.FindControl("rdbAns")).SelectedItem.Value;
                    vsa.Remarks = ((TextBox)rpt.FindControl("txtRemarks")).Text.Trim();
                    vsa.Insert();
                }
            }

            tranX.Commit();
            tranX.Dispose();
            con.Close();
            con.Dispose();
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Saved Successfully.....Donor ID: " + VisitorID + "');clearform();", true);

            var sqlCmd = new StringBuilder("SELECT bv.IdProof,bv.IdProofNo,bv.Visitor_ID,CONCAT(bv.Title,' ',bv.Name)DonorName,bv.dtBirth,bv.Gender,bv.Kin_Name,bv.Relation,bv.Email,bvh.Visit_ID,");
            sqlCmd.Append(" CONCAT(bv.Address,',',bv.City,',',bv.PinCode)Address,IF(IFNULL(bv.MobileNo,'')='',IFNULL(bv.PhoneNo,''),bv.MobileNo)ContactNo,");
            sqlCmd.Append(" DATE_FORMAT(bv.DOB,'%d-%b-%y')DOB,IFNULL(bbm.BloodGroup,'')BloodGroup,bva.Question,bva.Answer AS Answer,IF( LENGTH(bva.Remarks)>0,CONCAT('Remarks : ', bva.Remarks),'') Remarks,DATE_FORMAT(bv.DOB,'%d-%b-%y')DOB,IFNULL(bbm.BloodGroup,'')BloodGroup,bva.Question,bva.Answer,bva.Remarks,CONCAT(bvh.Blood_Pressure,' ', 'mm/Hg') Blood_Pressure,CONCAT(bvh.Weight,' ', 'kg') Weight,CONCAT(bvh.Pulse,' ', 'p-m') Pulse,CONCAT(bvh.Hb,' ', 'Hb') Hb,CONCAT(bvh.Height,' ', 'cm') Height,CONCAT(bvh.Temprature,' ', 'cm') Temprature,bvh.GPE,IF(bvh.isFit=1,'Fit','UnFit') isFit");//IF( bva.Answer=1,'YES','NO') Answer
            sqlCmd.Append(" FROM bb_visitors_history bvh ");
            sqlCmd.Append(" INNER JOIN bb_visitors bv ON bvh.Visitor_ID=bv.Visitor_ID ");
            sqlCmd.Append(" LEFT JOIN bb_bloodgroup_master bbm ON bbm.id=bv.BloodGroup_Id ");
            sqlCmd.Append(" LEFT JOIN bb_visitors_answer bva ON bva.Visitor_ID=bvh.Visitor_ID AND bva.VisitID=bvh.Visit_ID  ");
            sqlCmd.Append(" WHERE bvh.Visit_ID='" + VisitID + "'");

            DataTable dtRegistrationDetails = StockReports.GetDataTable(sqlCmd.ToString());
            DataSet ds = new DataSet();
            ds.Tables.Add(dtRegistrationDetails.Copy());
            ds.Tables[0].TableName = "RegistrationDetails";

            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[1].TableName = "ClientImage";

            //ds.WriteXmlSchema(@"E:\\DonorRegistrationDetails.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "BBDonorRegistration";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "location.href='DonorRegistration.aspx';", true);
            rdbFit.SelectedValue = "No";
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblerrmsg.ClientID + "');", true);

            tranX.Rollback();
            tranX.Dispose();
            con.Close();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            con.Dispose();
          
        }
    }

    private bool validation()
    {
        string visit_id = txtVisit.Text.Trim();

        string str = " SELECT isdonated,isscreened,isgrouped,iscomponent,istested,DATE_FORMAT(dtentry,'%d-%b-%y')dtentry  FROM bb_visitors_history WHERE Visitor_ID='" + txtDonorId.Text.Trim() + "' and  istested=0 and isfit=1";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["isdonated"].ToString() == "0")
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM235','" + lblerrmsg.ClientID + "');", true);
               // return false;
            }
            if (dt.Rows[0]["isscreened"].ToString() == "0" && dt.Rows[0]["isgrouped"].ToString() == "0" && dt.Rows[0]["iscomponent"].ToString() == "0" && dt.Rows[0]["istested"].ToString() == "0")
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM236','" + lblerrmsg.ClientID + "');", true);

                //return false;
            }
            if (dt.Rows[0]["isscreened"].ToString() == "0" && dt.Rows[0]["isgrouped"].ToString() == "1" && dt.Rows[0]["iscomponent"].ToString() == "0" && dt.Rows[0]["istested"].ToString() == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM237','" + lblerrmsg.ClientID + "');", true);

                return false;
            }
            if (dt.Rows[0]["isscreened"].ToString() == "0" && dt.Rows[0]["isgrouped"].ToString() == "3" && dt.Rows[0]["iscomponent"].ToString() == "0" && dt.Rows[0]["istested"].ToString() == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM238','" + lblerrmsg.ClientID + "');", true);

                return false;
            }
            if (dt.Rows[0]["isscreened"].ToString() == "1" && dt.Rows[0]["isgrouped"].ToString() == "3" && dt.Rows[0]["iscomponent"].ToString() == "0" && dt.Rows[0]["istested"].ToString() == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM239','" + lblerrmsg.ClientID + "');", true);

                return false;
            }
            if (dt.Rows[0]["isscreened"].ToString() == "3" && dt.Rows[0]["isgrouped"].ToString() == "3" && dt.Rows[0]["iscomponent"].ToString() == "0" && dt.Rows[0]["istested"].ToString() == "0")
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM240','" + lblerrmsg.ClientID + "');", true);

                //return false;
            }
            if (dt.Rows[0]["isscreened"].ToString() == "3" && dt.Rows[0]["isgrouped"].ToString() == "3" && dt.Rows[0]["iscomponent"].ToString() == "3" && dt.Rows[0]["istested"].ToString() == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM241','" + lblerrmsg.ClientID + "');", true);

                return false;
            }
        }
        if (rbAge.Checked == true)
        {
            if (txtAge1.Text == "")
            {
              // ScriptManager.RegisterStartupScript(this, this.GetType(), "key6", "modelAlert('Age should not be blank',function(){});", true);
                lblerrmsg.Text = "Age should not be blank";
                rdbFit.SelectedValue = "No";
                return false;
            }
            int age = Util.GetInt(txtAge1.Text.Trim());
            if (age < 18 || age > 60)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM215','" + lblerrmsg.ClientID + "');", true);
                rdbFit.SelectedValue = "No";
                return false;
            }
        }
        return true;
    }

    [WebMethod(EnableSession = true)]
    public static string getCity(string CountryID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT * FROM City_master_blood_bank WHERE CountryID=" + CountryID + "");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string CityInsert(string CityName,int CountryID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);
        try
        {
            string res = "";
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT COUNT(*) FROM City_master_blood_bank WHERE City='" + CityName + "' AND CountryId=" + CountryID + "");
            int IsCityExists = Util.GetInt(MySqlHelper.ExecuteScalar(objTran, CommandType.Text, sb.ToString()));

            if (IsCityExists > 0)
            {
                int result = 2;
                objTran.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(result);
            }
            string sqlCMD = "INSERT INTO City_master_blood_bank(City,CountryId,CreatedDate,CreatedBy) VALUES('" + CityName + "','" + CountryID + "',CurDate(),'" + HttpContext.Current.Session["ID"].ToString() + "')";

            int IsSave = Util.GetInt(MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, sqlCMD));
            
            if (IsSave == 0)
            {
                res = "0";
                objTran.Rollback();
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { res, response = AllGlobalFunction.errorMessage, message = "Error In Finance Integration" });
            }
            objTran.Commit();
            objTran.Dispose();
            con.Close();
            con.Dispose();

            return Newtonsoft.Json.JsonConvert.SerializeObject(IsSave);
        }
        catch (Exception ex)
        {
            return "";
        }
    }
}