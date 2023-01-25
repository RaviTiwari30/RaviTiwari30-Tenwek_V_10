using Resources;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class Design_EDP_HospitalMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindddlItems();
            bindSubcategory();
            bindCategoryID();
            BindGlobalFile();
            bindCity();
            All_LoadData.BindPanelOPD(ddlDefaultPanel);
            bindFormat();
            All_LoadData.bindCenterDropDownList(ddlCenter, "", "Select");
        }
        txtFinYear.Attributes.Add("readonly", "true");
    }

    private DataTable BindItem()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ItemID,TypeName FROM f_itemmaster im INNER JOIN f_subcategorymaster scm ON scm.subcategoryID=im.SubCategoryID INNER JOIN f_configrelation cr ON cr.CategoryID=scm.CategoryID WHERE im.isActive=1 AND cr.ConfigID IN(20,29,24)ORDER BY Typename ");
        return dt;
    }

    private void BindddlItems()
    {
        DataTable dt = BindItem();
        if (dt.Rows.Count > 0)
        {
            ddlRegistration.DataSource = dt;
            ddlRegistration.DataTextField = "TypeName";
            ddlRegistration.DataValueField = "ItemID";
            ddlRegistration.DataBind();
            ddlRegistration.Items.Insert(0, "Select");
            ddlOTItem.DataSource = dt;
            ddlOTItem.DataTextField = "TypeName";
            ddlOTItem.DataValueField = "ItemID";
            ddlOTItem.DataBind();
            ddlOTItem.Items.Insert(0, "Select");
        }
    }

    private void bindFormat()
    {
        DataTable format = StockReports.GetDataTable("SELECT ID,TypeName FROM master_IdFormat WHERE IsActive=1");
        ddlType.DataSource = format;
        ddlType.DataTextField = "TypeName";
        ddlType.DataValueField = "ID";
        ddlType.DataBind();
        ddlType.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void bindSubcategory()
    {
        DataView dv = LoadCacheQuery.loadSubCategory().DefaultView;
        dv.RowFilter = "ConfigID = '1'";
        DataTable dt = dv.ToTable();
        if (dt.Rows.Count > 0)
        {
            ddlDoctorSubID.DataSource = dt;
            ddlDoctorSubID.DataTextField = "Name";
            ddlDoctorSubID.DataValueField = "SubCategoryID";
            ddlDoctorSubID.DataBind();
        }
    }

    private void bindCategoryID()
    {
        ddlPathologyCategoryID.Items.AddRange(LoadItems(CreateStockMaster.LoadCategoryByCategoryID(CreateStockMaster.LoadCategoryByConfigID("3"))));
        ddlRadiologyCategoryID.Items.AddRange(LoadItems(CreateStockMaster.LoadCategoryByCategoryID(CreateStockMaster.LoadCategoryByConfigID("3"))));
        ddlOPDAppointmentCategoryID.Items.AddRange(LoadItems(CreateStockMaster.LoadCategoryByCategoryID(CreateStockMaster.LoadCategoryByConfigID("5"))));

        ddlPathologyCategoryID.DataBind();
        ddlRadiologyCategoryID.DataBind();
        ddlOPDAppointmentCategoryID.DataBind();
    }

    private void bindCity()
    {
        DataTable dt = All_LoadData.BindCity(Resource.DefaultDistrictID,Resource.DefaultStateID);
        if (dt.Rows.Count > 0)
        {
            ddlDefaultCity.DataSource = dt;
            ddlDefaultCity.DataTextField = "City";
            ddlDefaultCity.DataValueField = "City";
            ddlDefaultCity.DataBind();
            ddlDefaultCity.SelectedIndex = ddlDefaultCity.Items.IndexOf(ddlDefaultCity.Items.FindByText(Resource.DefaultCity));
        }
    }

    public ListItem[] LoadItems(DataTable str)
    {
        try
        {
            if (str == null)
            {
                ListItem[] iItems = new ListItem[1];
                iItems[0] = new ListItem("", "");
                return iItems;
            }

            ListItem[] Items = new ListItem[str.Rows.Count];

            for (int i = 0; i < str.Rows.Count; i++)
            {
                Items[i] = new ListItem(str.Rows[i][0].ToString(), str.Rows[i][1].ToString());
            }

            return Items;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;
        }
    }

    private void BindGlobalFile()
    {
        try
        {
            txtName.Text = Resource.ClientName;
            txtApplicationURLName.Text = Resource.ApplicationName;
            txtFullName.Text = Resource.ClientFullName;
            txtAddress.Text = Resource.ClientAddress;
            txtContactNo.Text = Resource.ClientTelophone;
            txtEmailID.Text = Resource.ClientEmail;
            txtWebSite.Text = Resource.ClientWebsite;
            txtReportHeader.Text = Resource.ReportHeader;

            lblBaseCurrency.Text = Resource.BaseCurrencyNotation;

            lblDefaultCountry.Text = Resource.DefaultCountry;
            lblBaseCurrencyID.Text = Resource.BaseCurrencyID;
            ddlDefaultCity.SelectedIndex = ddlDefaultCity.Items.IndexOf(ddlDefaultCity.Items.FindByText(Resource.DefaultCity));
            ddlLanguage.SelectedIndex = ddlLanguage.Items.IndexOf(ddlLanguage.Items.FindByValue(Resource.Lang_Code));
            ddlPathologyCategoryID.SelectedIndex = ddlPathologyCategoryID.Items.IndexOf(ddlPathologyCategoryID.Items.FindByValue(Resource.PathologyCategoryID));
            ddlRadiologyCategoryID.SelectedIndex = ddlRadiologyCategoryID.Items.IndexOf(ddlRadiologyCategoryID.Items.FindByValue(Resource.RadiologyCategoryID));
            ddlOPDAppointmentCategoryID.SelectedIndex = ddlOPDAppointmentCategoryID.Items.IndexOf(ddlOPDAppointmentCategoryID.Items.FindByValue(Resource.OPDAppointmentCategoryID));
            ddlDefaultPanel.SelectedIndex = ddlDefaultPanel.Items.IndexOf(ddlDefaultPanel.Items.FindByValue(Resource.DefaultPanelID));
            rblOPDOldPatient.SelectedIndex = rblOPDOldPatient.Items.IndexOf(rblOPDOldPatient.Items.FindByValue(Resource.OldPatientLink));
            rblPatientDemographics.SelectedIndex = rblPatientDemographics.Items.IndexOf(rblPatientDemographics.Items.FindByValue(Resource.IsReadOnly));
            rblNotification.SelectedIndex = rblNotification.Items.IndexOf(rblNotification.Items.FindByValue(Resource.NotificationDisplay));
            rblTaxRequired.SelectedIndex = rblTaxRequired.Items.IndexOf(rblTaxRequired.Items.FindByValue(Resource.TaxRequired));
            rblOPDCard.SelectedIndex = rblOPDCard.Items.IndexOf(rblOPDCard.Items.FindByValue(Resource.OPDCard));
            rblReceiptGenerate.SelectedIndex = rblReceiptGenerate.Items.IndexOf(rblReceiptGenerate.Items.FindByValue(Resource.IsReceipt));
            rblPatientPhoto.SelectedIndex = rblPatientPhoto.Items.IndexOf(rblPatientPhoto.Items.FindByValue(Resource.ShowPatientPhoto));
            rblPatientOutstanding.SelectedIndex = rblPatientOutstanding.Items.IndexOf(rblPatientOutstanding.Items.FindByValue(Resource.ShowPatientOutstanding));
            rblIPDBillFinalised.SelectedIndex = rblIPDBillFinalised.Items.IndexOf(rblIPDBillFinalised.Items.FindByValue(Resource.IsBilledFinalised));
            rblSMSApplicable.SelectedIndex = rblSMSApplicable.Items.IndexOf(rblSMSApplicable.Items.FindByValue(Resource.SMSApplicable));
            rblTokenDisplay.SelectedIndex = rblTokenDisplay.Items.IndexOf(rblTokenDisplay.Items.FindByValue(Resource.TokenDisplay));
            
            rblHospitalChargesApplicable.SelectedIndex = rblHospitalChargesApplicable.Items.IndexOf(rblHospitalChargesApplicable.Items.FindByValue(Resource.HospitalChargeApplicable));
            rblRegistrationChargesApplicable.SelectedIndex = rblRegistrationChargesApplicable.Items.IndexOf(rblRegistrationChargesApplicable.Items.FindByValue(Resource.RegistrationChargeApplicable));
            rblApplicationRun.SelectedIndex = rblApplicationRun.Items.IndexOf(rblApplicationRun.Items.FindByValue(Resource.ApplicationRunCentreWise));

            ddlCountryCache.SelectedIndex = ddlCountryCache.Items.IndexOf(ddlCountryCache.Items.FindByValue(Resource.CountryCacheTimeOut));
            ddlCityCache.SelectedIndex = ddlCityCache.Items.IndexOf(ddlCityCache.Items.FindByValue(Resource.CityCacheTimeOut));
            ddlDoctorCache.SelectedIndex = ddlDoctorCache.Items.IndexOf(ddlDoctorCache.Items.FindByValue(Resource.DoctorCacheTimeOut));
            ddlGeneralStoreGRNCache.SelectedIndex = ddlGeneralStoreGRNCache.Items.IndexOf(ddlGeneralStoreGRNCache.Items.FindByValue(Resource.General_GRN_ItemsCacheTimeOut));
            ddlMedicalStoreGRNCache.SelectedIndex = ddlMedicalStoreGRNCache.Items.IndexOf(ddlMedicalStoreGRNCache.Items.FindByValue(Resource.Medical_GRN_ItemsCacheTimeOut));
            ddlGeneralStoreCachePR.SelectedIndex = ddlGeneralStoreCachePR.Items.IndexOf(ddlGeneralStoreCachePR.Items.FindByValue(Resource.General_PR_ItemsCacheTimeOut));
            ddlMedicalStoreCachePR.SelectedIndex = ddlMedicalStoreCachePR.Items.IndexOf(ddlMedicalStoreCachePR.Items.FindByValue(Resource.Medical_PR_ItemsCacheTimeOut));
            ddlOPDInvCache.SelectedIndex = ddlOPDInvCache.Items.IndexOf(ddlOPDInvCache.Items.FindByValue(Resource.OPD_InvestigationCacheTimeOut));
            ddlOPDPanelCache.SelectedIndex = ddlOPDPanelCache.Items.IndexOf(ddlOPDPanelCache.Items.FindByValue(Resource.PanelOPDCacheTimeOut));
            ddlIPDPanelCache.SelectedIndex = ddlIPDPanelCache.Items.IndexOf(ddlIPDPanelCache.Items.FindByValue(Resource.PanelIPDCacheTimeOut));
            ddlReferDocCache.SelectedIndex = ddlReferDocCache.Items.IndexOf(ddlReferDocCache.Items.FindByValue(Resource.ReferDoctorCacheTimeOut));
            ddlCategoryCache.SelectedIndex = ddlCategoryCache.Items.IndexOf(ddlCategoryCache.Items.FindByValue(Resource.CategoryCacheTimeOut));
            ddlSubCategoryCache.SelectedIndex = ddlSubCategoryCache.Items.IndexOf(ddlSubCategoryCache.Items.FindByValue(Resource.SubCategoryCacheTimeOut));
            ddlAppointmentTypeCache.SelectedIndex = ddlAppointmentTypeCache.Items.IndexOf(ddlAppointmentTypeCache.Items.FindByValue(Resource.AppointmentTypeCacheTimeOut));
            ddlBankCache.SelectedIndex = ddlBankCache.Items.IndexOf(ddlBankCache.Items.FindByValue(Resource.BankCacheTimeOut));
            ddlCurrencyCache.SelectedIndex = ddlCurrencyCache.Items.IndexOf(ddlCurrencyCache.Items.FindByValue(Resource.CurrencyCacheTimeOut));

            ddlRegistration.SelectedIndex = ddlRegistration.Items.IndexOf(ddlRegistration.Items.FindByValue(Resource.RegistrationItemID));
            ddlOTItem.SelectedIndex = ddlOTItem.Items.IndexOf(ddlOTItem.Items.FindByValue(Resource.OTItemID));
            string AdmissionItem = Resource.IPD_Room_DocVisit_Admission_Charges;
            if (AdmissionItem.ToString() != "")
            {
                if (AdmissionItem.Split('#')[0].ToString() == "1")
                    chkAdmissionRoom.Checked = true;
                if (AdmissionItem.Split('#')[1].ToString() == "1")
                    chkDoctorVisit.Checked = true;
                if (AdmissionItem.Split('#')[2].ToString() == "1")
                    chkAdmissionCharges.Checked = true;
            }
            ddlDoctorSubID.SelectedIndex = ddlDoctorSubID.Items.IndexOf(ddlDoctorSubID.Items.FindByValue(Resource.AdmissionDoctorVisitSubCatrgoryID));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            //check city Exist
            if (ddlDefaultCity.Items.Count <= 0)
            {
                lblMsg.Text = "City Not Available Under Selected Country";
                return;
            }
            XmlDocument loResource = new XmlDocument();
            loResource.Load(Server.MapPath("~/App_GlobalResources/Resource.resx"));

            XmlNode xClientName = loResource.SelectSingleNode("root/data[@name='ClientName']/value");
            XmlNode xApplicationURLName = loResource.SelectSingleNode("root/data[@name='ApplicationName']/value");
            XmlNode xClientFullName = loResource.SelectSingleNode("root/data[@name='ClientFullName']/value");
            XmlNode xClientAddress = loResource.SelectSingleNode("root/data[@name='ClientAddress']/value");
            XmlNode xClientTelophone = loResource.SelectSingleNode("root/data[@name='ClientTelophone']/value");
            XmlNode xClientEmail = loResource.SelectSingleNode("root/data[@name='ClientEmail']/value");
            XmlNode xClientWebsite = loResource.SelectSingleNode("root/data[@name='ClientWebsite']/value");

            XmlNode xReportHeader = loResource.SelectSingleNode("root/data[@name='ReportHeader']/value");
            XmlNode xDefaultCountry = loResource.SelectSingleNode("root/data[@name='DefaultCountry']/value");
            XmlNode xDefaultCity = loResource.SelectSingleNode("root/data[@name='DefaultCity']/value");
            XmlNode xLanguage = loResource.SelectSingleNode("root/data[@name='Lang_Code']/value");
            XmlNode xPathologyCategoryID = loResource.SelectSingleNode("root/data[@name='PathologyCategoryID']/value");
            XmlNode xRadiologyCategoryID = loResource.SelectSingleNode("root/data[@name='RadiologyCategoryID']/value");
            XmlNode xOPDAppointmentCategoryID = loResource.SelectSingleNode("root/data[@name='OPDAppointmentCategoryID']/value");
            XmlNode xOPDPanelID = loResource.SelectSingleNode("root/data[@name='DefaultPanelID']/value");
            XmlNode xOPDPanel = loResource.SelectSingleNode("root/data[@name='DefaultPanel']/value");
            XmlNode xOldPatientLink = loResource.SelectSingleNode("root/data[@name='OldPatientLink']/value");
            XmlNode xIsReadOnly = loResource.SelectSingleNode("root/data[@name='IsReadOnly']/value");
            XmlNode xNotificationDisplay = loResource.SelectSingleNode("root/data[@name='NotificationDisplay']/value");
            XmlNode xTaxRequired = loResource.SelectSingleNode("root/data[@name='TaxRequired']/value");
            XmlNode xrblOPDCard = loResource.SelectSingleNode("root/data[@name='OPDCard']/value");
            XmlNode xrblReceiptGenerate = loResource.SelectSingleNode("root/data[@name='IsReceipt']/value");
            XmlNode xrblShowPatientPhoto = loResource.SelectSingleNode("root/data[@name='ShowPatientPhoto']/value");
            XmlNode xrblShowPatientOutstanding = loResource.SelectSingleNode("root/data[@name='ShowPatientOutstanding']/value");
            XmlNode xrblIsBilledFinalised = loResource.SelectSingleNode("root/data[@name='IsBilledFinalised']/value");
            XmlNode xrblSMSApplicable = loResource.SelectSingleNode("root/data[@name='SMSApplicable']/value");


            XmlNode xCountryCacheTimeOut = loResource.SelectSingleNode("root/data[@name='CountryCacheTimeOut']/value");
            XmlNode xCityCacheTimeOut = loResource.SelectSingleNode("root/data[@name='CityCacheTimeOut']/value");
            XmlNode xDoctorCacheTimeOut = loResource.SelectSingleNode("root/data[@name='DoctorCacheTimeOut']/value");
            XmlNode xGeneral_GRN_ItemsCacheTimeOut = loResource.SelectSingleNode("root/data[@name='General_GRN_ItemsCacheTimeOut']/value");
            XmlNode xMedical_GRN_ItemsCacheTimeOut = loResource.SelectSingleNode("root/data[@name='Medical_GRN_ItemsCacheTimeOut']/value");
            XmlNode xGeneral_PR_ItemsCacheTimeOut = loResource.SelectSingleNode("root/data[@name='General_PR_ItemsCacheTimeOut']/value");
            XmlNode xMedical_PR_ItemsCacheTimeOut = loResource.SelectSingleNode("root/data[@name='Medical_PR_ItemsCacheTimeOut']/value");
            XmlNode xOPD_InvestigationCacheTimeOut = loResource.SelectSingleNode("root/data[@name='OPD_InvestigationCacheTimeOut']/value");
            XmlNode xPanelOPDCacheTimeOut = loResource.SelectSingleNode("root/data[@name='PanelOPDCacheTimeOut']/value");
            XmlNode xPanelIPDCacheTimeOut = loResource.SelectSingleNode("root/data[@name='PanelIPDCacheTimeOut']/value");
            XmlNode xReferDoctorCacheTimeOut = loResource.SelectSingleNode("root/data[@name='ReferDoctorCacheTimeOut']/value");
            XmlNode xCategoryCacheTimeOut = loResource.SelectSingleNode("root/data[@name='CategoryCacheTimeOut']/value");
            XmlNode xSubCategoryCacheTimeOut = loResource.SelectSingleNode("root/data[@name='SubCategoryCacheTimeOut']/value");
            XmlNode xAppointmentTypeCacheTimeOut = loResource.SelectSingleNode("root/data[@name='AppointmentTypeCacheTimeOut']/value");
            XmlNode xBankCacheTimeOut = loResource.SelectSingleNode("root/data[@name='BankCacheTimeOut']/value");
            XmlNode xCurrencyCacheTimeOut = loResource.SelectSingleNode("root/data[@name='CurrencyCacheTimeOut']/value");

            XmlNode xRegistrationItemID = loResource.SelectSingleNode("root/data[@name='RegistrationItemID']/value");
            XmlNode xOTItemID = loResource.SelectSingleNode("root/data[@name='OTItemID']/value");
            XmlNode xIPD_Room_DocVisit_Admission_Charges = loResource.SelectSingleNode("root/data[@name='IPD_Room_DocVisit_Admission_Charges']/value");
            XmlNode xAdmissionDoctorVisitSubCatrgoryID = loResource.SelectSingleNode("root/data[@name='AdmissionDoctorVisitSubCatrgoryID']/value");
            XmlNode xTokenDisplay = loResource.SelectSingleNode("root/data[@name='TokenDisplay']/value");

            XmlNode xHospitalChargesApplicable = loResource.SelectSingleNode("root/data[@name='HospitalChargesApplicable']/value");
            XmlNode xRegistrationChargesApplicable = loResource.SelectSingleNode("root/data[@name='RegistrationChargesApplicable']/value");
            XmlNode xApplicationRunCentreWise = loResource.SelectSingleNode("root/data[@name='ApplicationRunCentreWise']/value");

            xClientName.InnerText = txtName.Text.Trim();
            xApplicationURLName.InnerText = txtApplicationURLName.Text.Trim();
            xClientFullName.InnerText = txtFullName.Text.Trim();
            xClientAddress.InnerText = txtAddress.Text.Trim();
            xClientTelophone.InnerText = txtContactNo.Text.Trim();
            xClientEmail.InnerText = txtEmailID.Text.Trim();
            xClientWebsite.InnerText = txtWebSite.Text.Trim();

            xReportHeader.InnerText = txtReportHeader.Text.Trim();
            xDefaultCountry.InnerText = lblDefaultCountry.Text.Trim();
            xDefaultCity.InnerText = ddlDefaultCity.SelectedItem.Text.Trim();
            xLanguage.InnerText = ddlLanguage.SelectedItem.Value;
            xPathologyCategoryID.InnerText = ddlPathologyCategoryID.SelectedItem.Value;
            xRadiologyCategoryID.InnerText = ddlRadiologyCategoryID.SelectedItem.Value;
            xOPDAppointmentCategoryID.InnerText = ddlOPDAppointmentCategoryID.SelectedItem.Value;
            xOPDPanelID.InnerText = ddlDefaultPanel.SelectedItem.Value;
            xOPDPanel.InnerText = ddlDefaultPanel.SelectedItem.Text;
            xOldPatientLink.InnerText = rblOPDOldPatient.SelectedItem.Value;
            xIsReadOnly.InnerText = rblPatientDemographics.SelectedItem.Value;
            xNotificationDisplay.InnerText = rblNotification.SelectedItem.Value;
            xTaxRequired.InnerText = rblTaxRequired.SelectedItem.Value;
            xrblOPDCard.InnerText = rblOPDCard.SelectedItem.Value;
            xrblReceiptGenerate.InnerText = rblReceiptGenerate.SelectedItem.Value;
            xrblShowPatientPhoto.InnerText = rblPatientPhoto.SelectedItem.Value;
            xrblShowPatientOutstanding.InnerText = rblPatientOutstanding.SelectedItem.Value;
            xrblIsBilledFinalised.InnerText = rblIPDBillFinalised.SelectedItem.Value;
            xrblSMSApplicable.InnerText = rblSMSApplicable.SelectedItem.Value;
            xTokenDisplay.InnerText = rblTokenDisplay.SelectedItem.Value;
            xHospitalChargesApplicable.InnerText = rblHospitalChargesApplicable.SelectedItem.Value;
            xRegistrationChargesApplicable.InnerText = rblRegistrationChargesApplicable.SelectedItem.Value;
            xApplicationRunCentreWise.InnerText = rblApplicationRun.SelectedItem.Value;

            xCountryCacheTimeOut.InnerText = ddlCountryCache.SelectedItem.Value;
            xCityCacheTimeOut.InnerText = ddlCityCache.SelectedItem.Value;
            xDoctorCacheTimeOut.InnerText = ddlDoctorCache.SelectedItem.Value;
          
            xGeneral_GRN_ItemsCacheTimeOut.InnerText = ddlGeneralStoreGRNCache.SelectedItem.Value;
            xMedical_GRN_ItemsCacheTimeOut.InnerText = ddlMedicalStoreGRNCache.SelectedItem.Value;
            xGeneral_PR_ItemsCacheTimeOut.InnerText = ddlGeneralStoreCachePR.SelectedItem.Value;
            xMedical_PR_ItemsCacheTimeOut.InnerText = ddlMedicalStoreCachePR.SelectedItem.Value;
            xOPD_InvestigationCacheTimeOut.InnerText = ddlOPDInvCache.SelectedItem.Value;
            xPanelOPDCacheTimeOut.InnerText = ddlOPDPanelCache.SelectedItem.Value;
            xPanelIPDCacheTimeOut.InnerText = ddlIPDPanelCache.SelectedItem.Value;
            xReferDoctorCacheTimeOut.InnerText = ddlReferDocCache.SelectedItem.Value;
            xCategoryCacheTimeOut.InnerText = ddlCategoryCache.SelectedItem.Value;
            xSubCategoryCacheTimeOut.InnerText = ddlSubCategoryCache.SelectedItem.Value;
            xAppointmentTypeCacheTimeOut.InnerText = ddlAppointmentTypeCache.SelectedItem.Value;
            xBankCacheTimeOut.InnerText = ddlBankCache.SelectedItem.Value;
            xCurrencyCacheTimeOut.InnerText = ddlCurrencyCache.SelectedItem.Value;

            if (ddlRegistration.SelectedIndex > 0)
                xRegistrationItemID.InnerText = ddlRegistration.SelectedItem.Value;
            else
                xRegistrationItemID.InnerText = "";
            if (ddlOTItem.SelectedIndex > 0)
                xOTItemID.InnerText = ddlOTItem.SelectedItem.Value;
            else
                xOTItemID.InnerText = "";
            string AdmissionCharges = "0";
            string RoomCharges = "0";
            string DoctorCharges = "0";
            if (chkAdmissionCharges.Checked)
                AdmissionCharges = "1";
            if (chkAdmissionRoom.Checked)
                RoomCharges = "1";
            if (chkDoctorVisit.Checked)
                DoctorCharges = "1";
            xIPD_Room_DocVisit_Admission_Charges.InnerText = RoomCharges + "#" + DoctorCharges + "#" + AdmissionCharges;
            if (ddlDoctorSubID.SelectedIndex > 0)
                xAdmissionDoctorVisitSubCatrgoryID.InnerText = ddlDoctorSubID.SelectedItem.Value;
            else
                xAdmissionDoctorVisitSubCatrgoryID.InnerText = "";
            loResource.Save(Server.MapPath("~/App_GlobalResources/Resource.resx"));
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
        }
    }
}