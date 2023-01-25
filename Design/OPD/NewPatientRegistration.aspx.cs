using System;
using System.Linq;
using System.Web.UI;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
public partial class Design_OPD_NewPatientRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindLanguageSpoken(ddlLanguageSpoken);
            All_LoadData.bindcountry(ddlPlaceOfBirth);
            All_LoadData.bindTitle(cmbTitle);
            All_LoadData.BindRelation(ddlRelationShip);
            All_LoadData.bindPurposeOfVisit(ddlPurposeOfVisit);
            All_LoadData.bindRace(ddlRace);
            All_LoadData.BindRelation(ddlRelationOf,"Self");
            loadPanel();
            ViewState["UserID"] = Session["ID"].ToString();
            txtHash.Text = Util.getHash();
            //if (lblAppID.Text == "")
            //{
            //    lblAppID.Text = Request.QueryString["App_ID"].ToString();
            //}
            if (Request.QueryString["App_ID"] != null && Request.QueryString["App_ID"].ToString() != "")
            {
                All_LoadData.bindcountry(ddlNationality);
                All_LoadData.bindState(ddlState, ddlNationality.SelectedValue);
                All_LoadData.bindDistrict(ddlDistrict, ddlNationality.SelectedValue,ddlState.SelectedValue);
                All_LoadData.bindCity(ddlCity, ddlDistrict.SelectedValue, ddlState.SelectedValue);
                All_LoadData.bindTaluk(ddlTaluka, ddlDistrict.SelectedValue);
                lblAppID.Text = Request.QueryString["App_ID"].ToString();
                BindDetail(lblAppID.Text);
                ddlPanel.Enabled = false;
                txtPostalAddress.Focus();
            }
            else
            {
                txtPatientFirstName.Focus();
                //All_LoadData.bindDistrict(ddlDistrict, ddlNationality.SelectedValue);
                //All_LoadData.bindCity(ddlCity, ddlDistrict.SelectedValue);
                //All_LoadData.bindTaluk(ddlTaluka, ddlDistrict.SelectedValue);
                lblAppID.Text = "0";
            }

            calucAutoRelatedInjury.SelectedDate = DateTime.Now.Date;
            calLegalRepresenative.StartDate = DateTime.Now;
            calucAutoRelatedInjury.EndDate = DateTime.Now;
            calWorkRelatedInjury.EndDate = DateTime.Now;
            calDOB.EndDate = DateTime.Now;
        }
        txtDOB.Attributes.Add("readOnly", "true");
        ucWorkRelatedInjury.Attributes.Add("readOnly", "true");
        ucAutoRelatedInjury.Attributes.Add("readOnly", "true");
        ucLegalRepresenative.Attributes.Add("readOnly", "true");

    }

    protected void loadPanel()
    {
        DataTable dtPanel = LoadCacheQuery.loadAllPanel();
        if (dtPanel.Rows.Count > 0)
        {
            foreach (DataRow dr in dtPanel.Rows)
            {
                ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString() + "#" + dr[3].ToString());
                ddlPanel.Items.Add(li1);
            }
            ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue(Resources.Resource.DefaultPanelID + "#" + Resources.Resource.DefaultPanelID));
           
        }
    }
    protected void BindDetail(string App_ID)
    {
        DataTable dtAppDetail = AllLoadData_OPD.bindAppointmentDetail(App_ID);
        if (dtAppDetail.Rows.Count > 0)
        {
            lblDoctorID.Text = dtAppDetail.Rows[0]["DoctorID"].ToString();
            rblSex.SelectedIndex = rblSex.Items.IndexOf(rblSex.Items.FindByValue(dtAppDetail.Rows[0]["Sex"].ToString()));
            cmbTitle.SelectedIndex = cmbTitle.Items.IndexOf(cmbTitle.Items.FindByText(dtAppDetail.Rows[0]["Title"].ToString()));

            txtPatientFirstName.Text = dtAppDetail.Rows[0]["PFirstName"].ToString();
            txtPatientLastName.Text = dtAppDetail.Rows[0]["PlastName"].ToString();

            if (dtAppDetail.Rows[0]["MaritalStatus"].ToString() == "Married")
            {
                ddlMarital.SelectedIndex = 1;
            }
            else if (dtAppDetail.Rows[0]["MaritalStatus"].ToString() == "Unmarried")
            {
                ddlMarital.SelectedIndex = 2;
            }
            else
            {
                ddlMarital.SelectedIndex = 0;
            }
            string st = dtAppDetail.Rows[0]["Age"].ToString().Split(' ')[1];

            if (Util.GetDateTime(dtAppDetail.Rows[0]["DOB"]).ToString("yyyy-MM-dd") != "0001-01-01")
            {
                rdDOB.Checked = true;
                rdAge.Checked = false;
                txtDOB.Text = Util.GetString(Util.GetDateTime(dtAppDetail.Rows[0]["DOB"].ToString()).ToString("dd-MMM-yyyy"));
                txtAge.Text = "";
                spnDOB.Attributes.Add("style", "display:block;color: Red; font-size: 10px;");
            }
            else
            {

                rdDOB.Checked = false;
                rdAge.Checked = true;
                txtDOB.Text = "";
                txtAge.Text = Util.GetString(dtAppDetail.Rows[0]["Age"]).Split(' ')[0];
                ddlAge.SelectedIndex = ddlAge.Items.IndexOf(ddlAge.Items.FindByText(dtAppDetail.Rows[0]["Age"].ToString().Split(' ')[1]));
                txtDOB.Enabled = true;
                spnAge.Attributes.Add("style", "display:block;color: Red; font-size: 10px;");
                
            }

            txtEmailAddress.Text = Util.GetString(dtAppDetail.Rows[0]["Email"]);

            txtTelephoneNo.Text = Util.GetString(dtAppDetail.Rows[0]["ContactNo"]);
            rblSex.SelectedIndex = rblSex.Items.IndexOf(rblSex.Items.FindByText(dtAppDetail.Rows[0]["Sex"].ToString()));
            ScriptManager.RegisterStartupScript(this, GetType(), "myFunction", "AutoGender();", true);

            ddlNationality.SelectedIndex = ddlNationality.Items.IndexOf(ddlNationality.Items.FindByText(dtAppDetail.Rows[0]["Nationality"].ToString()));

            All_LoadData.bindState(ddlState, ddlNationality.SelectedValue);
            ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(dtAppDetail.Rows[0]["StateID"].ToString()));

            All_LoadData.bindDistrict(ddlDistrict, ddlNationality.SelectedValue,ddlState.SelectedValue);
            ddlDistrict.SelectedIndex = ddlDistrict.Items.IndexOf(ddlDistrict.Items.FindByValue(dtAppDetail.Rows[0]["DistrictID"].ToString()));

            All_LoadData.bindCity(ddlCity, ddlDistrict.SelectedValue,ddlState.SelectedValue);
           // All_LoadData.bindTaluk(ddlTaluka, ddlDistrict.SelectedValue);

            ddlPhysician.SelectedIndex = ddlPhysician.Items.IndexOf(ddlPhysician.Items.FindByText(dtAppDetail.Rows[0]["RefDocID"].ToString()));
            string PanelID = dtAppDetail.Rows[0]["PanelID"].ToString();
            ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue(PanelID));

            ddlPurposeOfVisit.SelectedIndex = ddlPurposeOfVisit.Items.IndexOf(ddlPurposeOfVisit.Items.FindByValue(dtAppDetail.Rows[0]["PurposeOfVisitID"].ToString()));
            ddlPhysician.SelectedIndex = ddlPhysician.Items.IndexOf(ddlPhysician.Items.FindByValue(dtAppDetail.Rows[0]["DoctorID"].ToString()));
            txtPostalAddress.Text = Util.GetString(dtAppDetail.Rows[0]["Address"]);
            lblReferPanelOPD.Text = PanelID.Split('#')[1];

            ddlCity.SelectedIndex = ddlCity.Items.IndexOf(ddlCity.Items.FindByValue(dtAppDetail.Rows[0]["CityID"].ToString()));
            ddlTaluka.SelectedIndex = ddlTaluka.Items.IndexOf(ddlTaluka.Items.FindByValue(dtAppDetail.Rows[0]["TalukaID"].ToString()));
            
            txtLandMark.Text = dtAppDetail.Rows[0]["LandMark"].ToString();
            txtPinCode.Text = dtAppDetail.Rows[0]["PinCode"].ToString();
            txtPlace.Text = dtAppDetail.Rows[0]["Place"].ToString();
            txtOccupation.Text = dtAppDetail.Rows[0]["Occupation"].ToString();
            ddlRelationOf.SelectedIndex = ddlRelationOf.Items.IndexOf(ddlRelationOf.Items.FindByText(dtAppDetail.Rows[0]["Relation"].ToString()));
            txtRelationName.Text = dtAppDetail.Rows[0]["RelationName"].ToString();
            ddlPatientType.SelectedIndex = ddlPatientType.Items.IndexOf(ddlPatientType.Items.FindByText(dtAppDetail.Rows[0]["PatientType"].ToString()));
            txtAdharCardNo.Text = dtAppDetail.Rows[0]["AdharCardNo"].ToString();
            lblsubcategoryID.Text = dtAppDetail.Rows[0]["SubcategoryID"].ToString();
            txtRelationContactNo.Text = dtAppDetail.Rows[0]["RelationContactNo"].ToString();
        }
    }
}