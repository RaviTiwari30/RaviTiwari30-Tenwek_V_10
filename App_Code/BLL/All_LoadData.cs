using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net.NetworkInformation;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Linq;
using System.Reflection;
using AjaxControlToolkit;
/// <summary>
/// Summary description for BindDate
/// </summary>
public class All_LoadData
{
    public All_LoadData()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public int findSurgery(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT COUNT(*)  FROM  f_ledgertnxdetail ltd WHERE  ltd.IsSurgery=1  AND ltd.TransactionID='" + TransactionID + "'  AND ltd.IsVerified=1");
        return Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
    }

    public static void CalculateGSTTax(decimal mrp, decimal qty, decimal discPercent, decimal discAmount, decimal igstTaxPercent, decimal cgstTaxPercent, decimal sgstTaxPercent, out decimal igstTaxAmt, out decimal cgstTaxAmt, out decimal sgstTaxAmt)
    {
        //decimal nonTaxableRate = (mrp * 100) / (100 + igstTaxPercent + cgstTaxPercent + sgstTaxPercent);
        //decimal discount = nonTaxableRate * discPercent / 100;
        //decimal taxableAmt = ((mrp - discount) * 100 * qty) / (100 + igstTaxPercent + cgstTaxPercent + sgstTaxPercent);

        //igstTaxAmt = Math.Round(taxableAmt * igstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
        //cgstTaxAmt = Math.Round(taxableAmt * cgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
        //sgstTaxAmt = Math.Round(taxableAmt * sgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);        

        decimal taxableAmt = (mrp * qty - discAmount) * 100 / (100 + igstTaxPercent + cgstTaxPercent + sgstTaxPercent);

        igstTaxAmt = Math.Round(taxableAmt * igstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
        cgstTaxAmt = Math.Round(taxableAmt * cgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
        sgstTaxAmt = Math.Round(taxableAmt * sgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
    }

    public static DataTable LoadEmployee()
    {
        return StockReports.GetDataTable("SELECT EmployeeID, NAME FROM Employee_master WHERE IsActive=1 order by Name ");
    }
    public static DataTable LoadHISMenu()
    {
        return StockReports.GetDataTable("select ID,MenuName from f_menumaster where active = 1 order by MenuName");
    }
    public static DataTable LoadRole()
    {
        return StockReports.GetDataTable("select ID,RoleName from f_rolemaster where active=1 order by RoleName");
    }
    public static DataTable LoadMenu_WithRoleWise(string RoleID)
    {
        return StockReports.GetDataTable("select distinct(mm.MenuName) from f_file_role fr inner join f_filemaster fm on fr.UrlID = fm.ID inner join f_menumaster mm on fm.MenuID = mm.ID where fr.Active = 1 and fr.RoleID='" + RoleID + "' order by mm.menuname");
    }
    public static DataTable LoadEmployee_Birthday()
    {
        return StockReports.GetDataTable(" SELECT CONCAT(Title,' ',NAME,' (',Desi_Name,')')NAME FROM pay_employee_master WHERE IsActive=1 AND DAY(dob)=DAY(CURRENT_DATE) AND MONTH(dob)=MONTH(CURRENT_DATE) ");
    }
    public static DataTable LoadCategory()
    {
        DataView CategoryView = LoadCacheQuery.loadCategory().DefaultView;
        CategoryView.RowFilter = " ConfigID in (2,3,6,7,8,9,10,11,20,14,15,24,25,26,27,29,30) ";
        return CategoryView.ToTable();
    }
    public static DataTable LoadAllCategory()
    {
        return LoadCacheQuery.loadCategory();
    }
    public static DataTable LoadDisplayName()
    {
        return StockReports.GetDataTable("select DisplayName from f_displaynamemaster where IsActive=1 order by DisplayName");
    }
    public static DataTable LoadCountry()
    {
        return StockReports.GetDataTable("SELECT CountryID,NAME FROM country_master");
    }
    public static DataTable LoadCountryByID(string CountryID)
    {
        return StockReports.GetDataTable("SELECT NAME,Currency,Notation,Address,PhoneNo,FaxNo,EmbassyAddress,EmbassyPhoneNo,EmbessyFaxNo,Isactive,IsBaseCurrency FROM Country_master WHERE CountryID='" + CountryID + "'");
    }
    public static DataTable LoadCurrency()
    {
        return StockReports.GetDataTable("SELECT CountryID,CONCAT(Currency,'$',Notation)CurrencyName,IsBaseCurrency FROM Country_master where IsActive=1 AND Currency IS NOT NULL ");
    }

    public static DataTable LoadBaseCurrency()
    {
        return StockReports.GetDataTable("SELECT CountryID,CONCAT(Currency,'$',Notation)CurrencyName FROM Country_master where IsActive=1 and IsBaseCurrency=1");
    }
    public static DataTable LoadCurrencyFactor(string CountryID)
    {
        DataTable dtCurrencyFactor = LoadCacheQuery.loadCurrency();
        if (string.IsNullOrEmpty(CountryID))
            return dtCurrencyFactor;
        else
        {
            DataView CurrencyView = dtCurrencyFactor.DefaultView;
            CurrencyView.RowFilter = "CountryID=" + CountryID + "";
            return CurrencyView.ToTable();
        }
    }
    public static DataTable dtOccupation()
    {
        return StockReports.GetDataTable("SELECT id,Occupation FROM Occupation_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindOccupation(DropDownList ddlObject)
    {
        DataTable dtData = dtOccupation();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Occupation";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtLanguageSpoken()
    {
        return StockReports.GetDataTable("SELECT id,LanguageSpoken FROM languagespoken_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindLanguageSpoken(DropDownList ddlObject)
    {
        DataTable dtData = dtLanguageSpoken();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "LanguageSpoken";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    public static DataTable dtRelationShip()
    {
        return StockReports.GetDataTable("SELECT id,relationship FROM relationship_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindRelationShip(DropDownList ddlObject)
    {
        DataTable dtData = dtRelationShip();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "relationship";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable BindCity(string districtID, string StateID)
    {
        return LoadCacheQuery.loadCity(districtID, StateID);
    }
    public static void bindcountry(DropDownList ddlObject)
    {
        DataTable dtData = LoadCacheQuery.loadCountry();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "Countryid";
            ddlObject.DataBind();
            DataRow[] dr = dtData.Select("IsBaseCurrency=1");
            if (dr.Length > 0)
                ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByValue(dr[0]["Countryid"].ToString()));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void bindAppointmentType(DropDownList ddlObject)
    {
        DataTable dtData = LoadCacheQuery.loadTypeOfAppointment();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "AppointmentType";
            ddlObject.DataValueField = "AppointmentTypeID";
            ddlObject.DataBind();
            DataRow[] dr = dtData.Select("IsDefault=1");
            if (dr.Length > 0)
                ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByText(dr[0]["AppointmentType"].ToString()));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void BindBank(DropDownList ddlObject)
    {
        DataTable dtData = dtBankMaster();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "BankName";
            ddlObject.DataValueField = "Bank_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("", ""));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtBankMaster()
    {
        return LoadCacheQuery.loadBank();
    }
    public static DataTable dtPhysiodoctor()
    {
        DataView DoctorView = All_LoadData.bindDoctor().DefaultView;
        DoctorView.RowFilter = "Department='Physiotherapy'";
        return DoctorView.ToTable();
    }
    public static void bindDoctor(DropDownList ddlObject, string type = "")
    {
        DataTable dtData = All_LoadData.bindDoctor();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "DoctorID";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtReferDoctor()
    {
        return LoadCacheQuery.loadReferDoctor();
    }

    public static DataTable dtPRO(string referDoctorID)
    {
        return LoadCacheQuery.loadPRO(referDoctorID);
    }
    public static void bindReferDoctor(DropDownList ddlObject, string type = "")
    {
        DataTable dtData = dtReferDoctor();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "DoctorID";
            ddlObject.DataBind();
            if (type != "")
                ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtPurposeOfVisit()
    {
        return StockReports.GetDataTable("select PurposeID,PurposeName from master_PurposeOfVisit where IsActive = 1 order by PurposeName");
    }

    public static DataTable dtComplane()
    {
        return StockReports.GetDataTable("SELECT Complain_ID,Complain FROM Complain_Master where IsActive=1 ORDER BY Complain");
    }

    public static void bindPurposeOfVisit(DropDownList ddlObject)
    {
        DataTable dtData = dtComplane();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Complain";
            ddlObject.DataValueField = "Complain_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable LoadDoctor_DateWise(DateTime AppDate)
    {
        return StockReports.GetDataTable("SELECT dm.DoctorID ,CONCAT(dm.title ,' ',dm.Name,'#',dh.Department)NAME FROM doctor_hospital dh INNER JOIN doctor_master dm ON dm.DoctorID = dh.DoctorID WHERE dh.Day = DATE_FORMAT('" + AppDate.ToString("yyyy-MM-dd") + "','%W')");
    }
    public static DataTable LoadDoctor()
    {
        return StockReports.GetDataTable("SELECT DoctorID,CONCAT(dm.title ,' ',dm.Name)NAME FROM doctor_master dm WHERE isactive=1 order by dm.Name");
    }
    public static DataTable dtPlace()
    {
        return StockReports.GetDataTable("SELECT PlaceID,NAME FROM place_master WHERE Isactive=1 ORDER BY NAME");
    }
    public static void BindPlace(DropDownList ddlObject)
    {
        DataTable dtData = dtPlace();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "PlaceID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    public static DataTable BindPaymentMode()
    {
        return StockReports.GetDataTable(" SELECT PaymentModeID,PaymentMode,PaymentType FROM paymentmode_master WHERE Active=1 ");
    }
    public static DataTable LoadSubcategoryIDByItemsID(string ItemID)
    {
        return StockReports.GetDataTable("SELECT sm.Name,sm.SubCategoryID FROM  f_itemmaster im INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=im.SubCategoryID WHERE im.ItemID='" + ItemID + "' ");
    }
    public static void bindSymptom(DropDownList ddlObject)
    {
        DataTable dtData = dtsymptom();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "SymptomsID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", ""));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtsymptom()
    {
        return StockReports.GetDataTable("SELECT SymptomsID,NAME FROM cpoe_symptoms WHERE IsActive=1 ORDER BY name");
    }
    public static DataTable message()
    {
        return StockReports.GetDataTable(" SELECT ID,MsgCode,Message FROM message_master");
    }
    public static DataTable ChkSymptoms(string LnxNo, string SymptomsID)
    {
        return StockReports.GetDataTable(" Select * from cpoe_symptoms_detail where LedgerTnxNo='" + LnxNo + "' and SymptomsID='" + SymptomsID + "'");
    }
    public static string receiptpaymentdetail(string ReceiptNo)
    {
        // return StockReports.ExecuteScalar("SELECT CAST(GROUP_CONCAT(PaymentMode,' ',BankName,' ',RefNo) AS CHAR)PaymentMode FROM f_receipt_paymentdetail WHERE ReceiptNo='" + ReceiptNo.ToString() + "' GROUP BY ReceiptNo");
        return StockReports.ExecuteScalar("SELECT concat(CAST(GROUP_CONCAT(TRUNCATE(S_Amount,2),' ',S_Notation,' ',PaymentMode) AS CHAR),' ',Ifnull(Refno,'') )PaymentMode FROM f_receipt_paymentdetail WHERE ReceiptNo='" + ReceiptNo.ToString() + "' GROUP BY ReceiptNo");
    }

    public static DataTable dtPatientType()
    {
        return StockReports.GetDataTable("select id,PatientType from patient_type where IsActive=1 order by id");
    }

    public static void bindPatientType(DropDownList ddlObject)
    {
        DataTable dtData = dtPatientType();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "PatientType";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByText("SELF"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtApprovalType()
    {
        return StockReports.GetDataTable("select Distinct(ApprovalType) from f_discountapproval order by id");
    }
    public static void bindApprovalType(DropDownList ddlObject)
    {
        DataTable dtData = dtApprovalType();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "ApprovalType";
            ddlObject.DataValueField = "ApprovalType";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void bindCity(DropDownList ddlObject, string districtID, string StateID)
    {
        DataTable dtData = All_LoadData.BindCity(districtID, StateID);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "City";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            DataRow[] dr = dtData.Select("IsDefault=1");
            if (dr.Length > 0)
                ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByText(dr[0]["City"].ToString()));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtLocation(string City)
    {
        return StockReports.GetDataTable("select distinct Location,IsDefault from Location_master where City='" + City + "' order by Location");
    }
    public static void bindLocation(DropDownList ddlObject, String City)
    {
        DataTable dtData = dtLocation(City);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Location";
            ddlObject.DataValueField = "Location";
            ddlObject.DataBind();
            DataRow[] dr = dtData.Select("IsDefault=1");
            if (dr.Length > 0)
                ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByText(dr[0]["Location"].ToString()));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtDiagnosis()
    {
        return StockReports.GetDataTable(" select Diagnosis,ID from Diagnosis_master where IsActive=1 order by Diagnosis asc");
    }

    public static void bindDiagnosis(DropDownList ddlObject)
    {
        DataTable dtData = dtDiagnosis();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Diagnosis";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "Select"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtPatientCategory()
    {
        return StockReports.GetDataTable(" select CatId,Category from patient_category where active=1");
    }
    public static void BindPatientCategory(DropDownList ddlObject)
    {
        DataTable dtData = dtPatientCategory();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Category";
            ddlObject.DataValueField = "CatId";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable bindTreatmentPlan()
    {
        return StockReports.GetDataTable("SELECT id,NAME FROM treatmentplan_master WHERE ACTIVE=1 order by name");
    }
    public static DataTable General(string TID, string PID, string lnxno)
    {
        return StockReports.GetDataTable(" SELECT ID,general,notes FROM cpoe_patient_general_notes WHERE TransactionId='" + TID + "' and PatientId='" + PID + "' and Ledgertranxno='" + lnxno + "'");
    }
    public static DataTable Remarks(string TID, string PID, string lnxno)
    {
        return StockReports.GetDataTable(" SELECT ID,remarks,notes FROM cpoe_patient_notes WHERE transactionID='" + TID + "' and patientid='" + PID + "' and Ledgertrnxno='" + lnxno + "'");
    }
    public static void BindRelation(DropDownList ddlObject, string type = "")
    {
        string[] Relation = AllGlobalFunction.KinRelation;
        for (int i = 0; i < Relation.Length; i++)
        {
            Relation[i] = Relation[i];
        }
        ddlObject.DataSource = Relation;
        ddlObject.DataBind();
        if (type != "")
            ddlObject.Items.Insert(0, new ListItem(type, "0"));
    }
    public static DataTable dtUserType(string Employee)
    {
        return StockReports.GetDataTable(" select Name,User_Type_ID from user_type_master where UserType='" + Employee + "'");
    }
    public static void bindUserType(DropDownList ddlObject, string Employee)
    {
        DataTable dtData = dtUserType(Employee);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "User_Type_ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void bindcheck(CheckBoxList ddlObject)
    {
        DataTable dtData = LoadRole();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "RoleName";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void BindBloodgroup(DropDownList ddlObject)
    {
        ddlObject.DataSource = AllGlobalFunction.BloobGroup;
        ddlObject.DataBind();
    }
    public static void bindTitle(DropDownList ddlObject)
    {
        ddlObject.DataSource = AllGlobalFunction.NameTitle;
        ddlObject.DataBind();
    }
    public static void Instruments(DropDownList ddlObject)
    {
        ddlObject.DataSource = AllGlobalFunction.Instruments;
        ddlObject.DataBind();
    }
    public static DataTable dtcategoryOPD()
    {
        return StockReports.GetDataTable(" SELECT  DisplayName,SubCategoryID FROM f_subcategorymaster WHERE Active=1 GROUP BY DisplayName ");
    }
    public static void bindcategoryOPD(GridView grdObject)
    {
        DataTable dtData = dtcategoryOPD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            grdObject.DataSource = dtData;
            grdObject.DataBind();
        }
        else
        {
            grdObject.DataSource = null;
            grdObject.DataBind();
        }
    }
    public static DataTable dtcategoryIPD()
    {
        return StockReports.GetDataTable("SELECT  DisplayName,SubCategoryID FROM f_subcategorymaster WHERE Active=1 GROUP BY DisplayName");
    }
    public static void bindcategoryIPD(GridView grdObject)
    {
        DataTable dtData = dtcategoryIPD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            grdObject.DataSource = dtData;
            grdObject.DataBind();
        }
        else
        {
            grdObject.DataSource = null;
            grdObject.DataBind();
        }
    }
    public static DataTable dtPanelOPD()
    {
        return StockReports.GetDataTable("SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,ReferenceCodeOPD FROM f_panel_master  ");//WHERE PanelID IN (SELECT DISTINCT (ReferenceCodeOPD)PanelID FROM f_panel_master)
    }
    public static void BindPanelOPD(DropDownList ddlObject)
    {
        DataTable dtData = dtPanelOPD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Company_Name";
            ddlObject.DataValueField = "PanelID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtPanelIPD()
    {
        return StockReports.GetDataTable(" SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID,ReferenceCode FROM f_panel_master WHERE PanelID IN (SELECT DISTINCT (ReferenceCode)PanelID FROM f_panel_master) ");
    }
    public static void BindPanelIPD(DropDownList ddlObject)
    {
        DataTable dtData = dtPanelIPD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Company_Name";
            ddlObject.DataValueField = "PanelID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtcopyFrmOPD(string ddlPanel)
    {
        return StockReports.GetDataTable("SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE PanelID=" + ddlPanel + "");
    }
    public static void BindcopyFrmOPD(DropDownList ddlObject, string ddlPanel)
    {
        DataTable dtData = dtcopyFrmOPD(ddlPanel);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "ScheduleChargeID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtcopyToOPD()
    {
        return StockReports.GetDataTable("SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE ScheduleChargeID NOT IN (SELECT DISTINCT ScheduleChargeID FROM f_ratelist WHERE Rate<>0)");
    }
    public static void BindcopyToOPD(DropDownList ddlObject)
    {
        DataTable dtData = dtcopyToOPD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "ScheduleChargeID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtcopyFrmIPD()
    {
        return StockReports.GetDataTable("SELECT NAME,PanelID FROM f_rate_schedulecharges WHERE ScheduleChargeID IN (SELECT DISTINCT ScheduleChargeID FROM f_ratelist_ipd WHERE Rate<>0)");
    }
    public static void BindcopyFrmIPD(DropDownList ddlObject)
    {
        DataTable dtData = dtcopyFrmIPD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "PanelID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtcopyToIPD()
    {
        return StockReports.GetDataTable("SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE ScheduleChargeID NOT IN (SELECT DISTINCT ScheduleChargeID FROM f_ratelist_ipd WHERE Rate<>0)");
    }
    public static void BindcopyToIPD(DropDownList ddlObject)
    {
        DataTable dtData = dtcopyToIPD();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "ScheduleChargeID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtDepartment()
    {
        return StockReports.GetDataTable("SELECT department FROM doctor_hospital GROUP BY department ORDER BY Department");
    }
    public static void BindDepartment(DropDownList ddlObject, string type)
    {
        DataTable dtData = dtDepartment();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "department";
            ddlObject.DataValueField = "department";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtBindOrderSet()
    {
        return StockReports.GetDataTable("SELECT DISTINCT(groups)Groups,GroupID FROM nursing_orderset_master where Isactive=1 order by GroupID");
    }
    public static void BindOrderSet(DropDownList ddlObject)
    {
        DataTable dtData = dtBindOrderSet();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Groups";
            ddlObject.DataValueField = "GroupID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    public static DataTable BindRadiologySubCategory()
    {
        DataView SubCategory = LoadCacheQuery.loadSubCategory().DefaultView;
        SubCategory.RowFilter = "CategoryID='" + Resources.Resource.RadiologyCategoryID + "'";
        return SubCategory.ToTable();
    }
    public static void BindOPDType(DropDownList ddlObject)
    {
        DataTable dtData = BindRadiologySubCategory();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "SubCategoryID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    public static DataTable dtBindPhysioDoctor()
    {
        return StockReports.GetDataTable(" SELECT CONCAT(Title,' ',NAME)NAME,dm.DoctorID FROM doctor_master  dm " +
         " INNER JOIN doctor_hospital dh ON dh.DoctorID= dm.DoctorID WHERE IsActive = 1 AND dh.Department='Physiotherapy' GROUP BY dh.DoctorID ORDER BY NAME");
    }
    public static void BindPhysioDoctor(DropDownList ddlObject)
    {
        DataTable dtData = dtBindPhysioDoctor();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "DoctorID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    public static DataTable LoadPanelOPD()
    {
        return LoadCacheQuery.loadOPDPanel(HttpContext.Current.Session["CentreID"].ToString());
    }
    public static DataTable LoadPanelIPD()
    {
        return LoadCacheQuery.loadIPDPanel(HttpContext.Current.Session["CentreID"].ToString());
    }
    public static DataTable LoadRole(string EmployeeID, string CentreID)
    {
        return StockReports.GetDataTable("SELECT UPPER(rm.RoleName) RoleName,rm.ID,rm.image,rm.background FROM f_login fl INNER JOIN f_rolemaster rm ON fl.RoleID=rm.ID AND fl.EmployeeID='" + EmployeeID + "' and fl.CentreID=" + CentreID + " AND fl.Active=1 AND rm.Active=1 ORDER BY rm.sequence");
    }
    public static DataTable CrystalReportLogo()
    {
        DataTable dtImg = new DataTable();
        dtImg.TableName = "Logo";
        dtImg.Columns.Add("ReportHeaderName");
        dtImg.Columns.Add("ClientEmail");
        dtImg.Columns.Add("ClientTelophone");
        dtImg.Columns.Add("ClientWebsite");
        dtImg.Columns.Add("ReportClientLogo", System.Type.GetType("System.Byte[]"));
        dtImg.Columns.Add("FooterLogoReport", System.Type.GetType("System.Byte[]"));
        DataTable dt = StockReports.GetDataTable("Select * from Center_Master where CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "'");
        DataRow drImg = dtImg.NewRow();
        //drImg["ReportHeaderName"] = HttpContext.GetGlobalResourceObject("Resource", "ReportHeader").ToString();
        //drImg["ClientEmail"] = HttpContext.GetGlobalResourceObject("Resource", "ClientEmail").ToString();
        //drImg["ClientTelophone"] = HttpContext.GetGlobalResourceObject("Resource", "ClientTelophone").ToString();
        //drImg["ClientWebsite"] = HttpContext.GetGlobalResourceObject("Resource", "ClientWebsite").ToString();
        string path = HttpContext.Current.Server.MapPath("../../" + HttpContext.GetGlobalResourceObject("Resource", "CrystalReportLogo"));

        if (dt.Rows[0]["ReportHeaderURL"].ToString() != string.Empty)
        {
            path = HttpContext.Current.Server.MapPath("~/Images/" + dt.Rows[0]["ReportHeaderURL"].ToString());
            if (!File.Exists(path))
                path = HttpContext.Current.Server.MapPath("../../" + HttpContext.GetGlobalResourceObject("Resource", "CrystalReportLogo"));
        }

        drImg["ReportHeaderName"] = dt.Rows[0]["CentreName"].ToString();
        drImg["ClientEmail"] = dt.Rows[0]["EmailID"].ToString();
        drImg["ClientTelophone"] = dt.Rows[0]["MobileNo"].ToString();
        drImg["ClientWebsite"] = dt.Rows[0]["Website"].ToString();

        FileStream fs = new FileStream(path, FileMode.Open, System.IO.FileAccess.Read);
        byte[] imgbyte = new byte[fs.Length + 1];
        fs.Read(imgbyte, 0, (int)fs.Length);
        fs.Close();
        string path1 = HttpContext.Current.Server.MapPath("~/Images/" + dt.Rows[0]["ReportHeaderURL"].ToString());
       // string path1 = dt.Rows[0]["ReportFooterURL"].ToString();

        if (dt.Rows[0]["ReportFooterURL"].ToString() != string.Empty)
        {
            path1 = HttpContext.Current.Server.MapPath("~/Images/" + dt.Rows[0]["ReportFooterURL"].ToString());
            if (!File.Exists(path1))
                path1 = HttpContext.Current.Server.MapPath("../../" + HttpContext.GetGlobalResourceObject("Resource", "ClientFooterLogo"));
        }

        FileStream fs1 = new FileStream(path1, FileMode.Open, System.IO.FileAccess.Read);
        byte[] imgbyte1 = new byte[fs1.Length + 1];
        fs1.Read(imgbyte1, 0, (int)fs1.Length);
        fs1.Close();
        drImg["FooterLogoReport"] = imgbyte1;
        drImg["ReportClientLogo"] = imgbyte;
        dtImg.Rows.Add(drImg);
        dtImg.AcceptChanges();
        return dtImg;
    }
    public static DataTable CrystalReportHeaderFooter(int CentreID)
    {
        DataTable dtHeaderFooterDetails = new DataTable();
        dtHeaderFooterDetails.TableName = "HeaderFooterDetails";
        dtHeaderFooterDetails.Columns.Add("HeaderDetails");
        dtHeaderFooterDetails.Columns.Add("FooterDetails");
        DataTable dtHeaderclient = StockReports.GetDataTable("select HeaderText,FooterText from Receipt_Header WHERE HeaderType='Pharmacy' AND CentreID=" + CentreID + " ");

        DataRow drImg = dtHeaderFooterDetails.NewRow();

        drImg["HeaderDetails"] = dtHeaderclient.Rows[0]["HeaderText"].ToString().Replace("&nbsp;", "");
        drImg["FooterDetails"] = dtHeaderclient.Rows[0]["FooterText"].ToString();
        dtHeaderFooterDetails.Rows.Add(drImg);
        dtHeaderFooterDetails.AcceptChanges();
        return dtHeaderFooterDetails;
    }
    public static string ClientHeader()
    {
        return HttpContext.GetGlobalResourceObject("Resource", "ReportHeader").ToString();
    }
    public static DataTable dtBindCard()
    {
        return StockReports.GetDataTable(" Select CardName,CONCAT(ItemId,'#',PanelId,'#',ID)ItemId from Card_Type_Master where IsActive=1 ORDER BY ID");
    }
    public static void BindCard(DropDownList ddlObject)
    {
        DataTable dtData = dtBindCard();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "CardName";
            ddlObject.DataValueField = "ItemId";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    public static decimal GovTaxPer()
    {
        return Util.GetDecimal(StockReports.ExecuteScalar("SELECT GovTaxPer FROM master_govtax Where IsActive=1 ORDER BY id DESC LIMIT 1 "));
    }
    public static DataTable LoadHISFrame()
    {
        return StockReports.GetDataTable("select ID,FrameName from f_framemenumaster where Isactive = 1 order by FrameName");
    }
    public static DataTable dtBindIFrame()
    {
        return StockReports.GetDataTable("Select FrameID,FrameName  from f_framemaster Where IsActive=1 Order by FrameID");
    }
    public static void BindIFrame(DropDownList ddlObject)
    {
        DataTable dtData = dtBindIFrame();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "FrameName";
            ddlObject.DataValueField = "FrameID";
            ddlObject.DataBind();
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtModeofArrival()
    {
        return StockReports.GetDataTable("SELECT id,ModeofArrival FROM ModeofArrival_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindModeofArrival(DropDownList ddlObject)
    {
        DataTable dtData = dtModeofArrival();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "ModeofArrival";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtAccompanied()
    {
        return StockReports.GetDataTable("SELECT id,Accompanied FROM Accompanied_master WHERE IsActive=1 ORDER By id");
    }
    public static void bindAccompanied(DropDownList ddlObject)
    {
        DataTable dtData = dtAccompanied();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Accompanied";
            ddlObject.DataValueField = "id";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void bindRole(DropDownList ddlObject, string Type = "")
    {
        DataTable dtData = LoadRole();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "RoleName";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            if (Type != "")
                ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static DataTable dtPriority()
    {
        return StockReports.GetDataTable("select ID,Name from f_priority");
    }
    public static void bindPriority(DropDownList ddlObject)
    {
        DataTable dtData = dtPriority();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    public static decimal GetEligiableDiscountPercent(string employeeID)
    {

        return Util.GetDecimal(StockReports.ExecuteScalar("SELECT IFNULL(em.Eligible_DiscountPercent,0) FROM employee_master em WHERE em.EmployeeID='" + employeeID + "'"));

    }


    public static DataTable BindPaymentModePanelWise(string PanelID)
    {
        return StockReports.GetDataTable(" CALL BindPaymentMode_PanelWise(" + PanelID + ")  ");
    }
    public static string FindDoctorByEmployeeID(string EmployeeID)
    {
        return StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee WHERE EmployeeID='" + EmployeeID + "'");
    }
    public static DataTable bindCssdSubcategoryID()
    {
        return StockReports.GetDataTable(" SELECT SubcategoryID,sub.Name as ItemName FROM f_ConfigRelation  cfg INNER JOIN f_subcategorymaster sub ON sub.CategoryID=cfg.CategoryID WHERE cfg.ConfigID IN ('11') and cfg.IsActive=1 ");
    }
    public static void bindMartialStatus(DropDownList ddlObject)
    {
        ddlObject.DataSource = AllGlobalFunction.MartialStatus;
        ddlObject.DataBind();
    }
    public static DataTable BindSubCategoryByCategory(string CategoryID)
    {
        DataView SubCategory = LoadCacheQuery.loadSubCategory().DefaultView;
        SubCategory.RowFilter = "CategoryID='" + CategoryID + "'";
        return SubCategory.ToTable();
    }
    public static void bindRace(DropDownList ddlObject)
    {
        ddlObject.DataSource = AllGlobalFunction.Race;
        ddlObject.DataBind();
    }
    public static DataTable dtAnesthesiadoctor()
    {
        //DataView DoctorView = All_LoadData.bindDoctor().DefaultView;
        //DoctorView.RowFilter = "Specialization='ANAESTHETIST'";
        //return DoctorView.ToTable();
        DataTable dtDoctor = All_LoadData.bindDoctor();
        return dtDoctor.AsEnumerable().Where(r => r.Field<string>("Specialization") == "Anaesthetist").AsDataView().ToTable();
    }
    public static DataTable dtPanel()
    {
        return StockReports.GetDataTable("SELECT  RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID FROM f_panel_master WHERE  IsActive=1 order by Company_Name ");
    }
    public static void bindPanel(DropDownList ddlObject, string Type = "")
    {
        DataTable dtData = dtPanel();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Company_Name";
            ddlObject.DataValueField = "PanelID";
            ddlObject.DataBind();
            if (Type != "")
                ddlObject.Items.Insert(0, new ListItem(Type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void bindPanellst(ListBox lstObject)
    {
        DataTable dtData = dtPanel();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            lstObject.DataSource = dtData;
            lstObject.DataTextField = "Company_Name";
            lstObject.DataValueField = "PanelID";
            lstObject.DataBind();
        }
        else
        {
            lstObject.DataSource = null;
            lstObject.DataBind();
        }
    }
    public static string GetAuthorization(int RoleId, string EmpId, string Type)
    {

        
        int CentreId = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        DataTable dt = StockReports.GetDataTable("CALL sp_UserAuth_By_Emp_Cen_Role('" + EmpId + "','" + CentreId + "','" + RoleId + "')");
    
        string Result = dt.Rows[0][Type].ToString();

        return Result;
    }
    public static int checkPageAuthorisation(string RoleID, string EmployeeID, string URL,int CentreID = 0)
    {
        if (CentreID == 0) {
            CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        }
        int PageAuthorisation = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_filemaster ps INNER JOIN user_pageaccess pa ON ps.ID=pa.UrlID " +
            " WHERE ps.URLName='" + URL + "' AND pa.RoleID='" + RoleID + "' AND pa.EmployeeID='" + EmployeeID + "'AND pa.CentreID='" + CentreID + "' AND ps.Active=1 AND pa.IsActive=1 "));
        return PageAuthorisation;
    }
    public static string GetFinYear(string date)
    {
        if (Convert.ToDateTime(date).ToString("dd-MMM").ToUpper() == "01-JAN")
            return Convert.ToDateTime(date).Year.ToString().Substring(2, 2);
        else
        {
            if (DateTime.Now > Convert.ToDateTime(date))
                return Convert.ToDateTime(date).Year.ToString().Substring(2, 2) + "-" + Convert.ToDateTime(date).AddYears(1).Year.ToString().Substring(2, 2);
            else
                return Convert.ToDateTime(date).AddYears(-1).Year.ToString().Substring(2, 2) + "-" + Convert.ToDateTime(date).Year.ToString().Substring(2, 2);
        }
    }
    public static DataTable BindMedicineSet()
    {
        DataTable dt = StockReports.GetDataTable(" Select ID,Setname from MedicineSetmaster where isactive=1 order by SetName ");
        if (dt.Rows.Count > 0)
            return dt;
        else
        {
            dt = null;
            return dt;
        }
    }
    public static string getCurrentPageName()
    {
        string[] strarry = HttpContext.Current.Request.UrlReferrer.AbsolutePath.Split('/');
        int lengh = strarry.Length;
        return strarry[lengh - 2] + "/" + strarry[lengh - 1];
    }
    public static DataTable dtbind_Center()
    {
        return StockReports.GetDataTable(" select CentreID,CentreName,IsDefault from center_master Where IsActive=1 order by CentreName");
    }
    public static void bindCenter(CheckBoxList Center)
    {
        DataTable dtData = dtbind_Center();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            Center.DataSource = dtData;
            Center.DataTextField = "CentreName";
            Center.DataValueField = "CentreID";
            Center.DataBind();
        }
        else
        {
            Center.DataSource = null;
            Center.DataBind();
        }
    }
    public static DataTable LoadFloor(int CentreID = 0)
    {

        int centreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
        if (CentreID > 0)
            centreID = CentreID;




        return StockReports.GetDataTable("SELECT NAME FROM floor_master Where CentreID=" + centreID + " ORDER BY SequenceNo");
    }
    public static void bindCenterDropDownList(DropDownList Center, string setDefault = "", string type = "")
    {
        DataTable dtData = dtbind_Center();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            Center.DataSource = dtData;
            Center.DataTextField = "CentreName";
            Center.DataValueField = "CentreID";
            Center.DataBind();
            if (setDefault != "")
                Center.SelectedIndex = Center.Items.IndexOf(Center.Items.FindByValue(Resources.Resource.DefaultCentreID));
            if (type != "")
                Center.Items.Insert(0, new ListItem(type, "0"));
        }
        else
        {
            Center.DataSource = null;
            Center.DataBind();
        }
    }
    public static DataTable bindDoctor()
    {
        return LoadCacheQuery.loadDoctor(HttpContext.Current.Session["CentreID"].ToString());
    }
    public static DataTable bindDoctorCentrewise(string CentreID)
    {
        return LoadCacheQuery.loadDoctor(CentreID);
    }
    public static void bindCentreCache()
    {
        DataTable dt = dtbind_Center();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                LoadCacheQuery.loadDataonCacheCentreWise(dt.Rows[i]["CentreID"].ToString());
            }
        }
    }
    public static DataTable bindMapItem(string typeID, string configID)
    {
        return StockReports.GetDataTable("SELECT cm.CentreName,cm.CentreID FROM map_item mi  INNER JOIN center_master cm ON mi.CentreID=cm.CentreID WHERE mi.TypeID='" + typeID + "' AND mi.ConfigID='" + configID + "' AND cm.IsActive=1 AND mi.IsActive=1");
    }
    public static string SelectCentre(CheckBoxList chkCentre)
    {
        string str = string.Empty;
        foreach (ListItem li in chkCentre.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }
        return str;
    }
    public static void getCenterDoctor(string doctorID, CheckBoxList chkCenter, string type)
    {
        DataTable dt = new DataTable();
        if (type == "Doctor")
            dt = StockReports.GetDataTable("SELECT DoctorID,CentreId FROM f_center_doctor WHERE DoctorID='" + doctorID + "'");
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                foreach (ListItem li in chkCenter.Items)
                {
                    if (dt.Rows[i]["CentreId"].ToString() == li.Value)
                    {
                        li.Selected = true;
                    }
                }
            }
        }
        else
        {
            foreach (ListItem li in chkCenter.Items)
            {
                li.Selected = false;
            }
        }
    }
    public static DataTable dtbind_Centre(string employee_id)
    {
        return StockReports.GetDataTable(" select CentreID,CentreName from Center_master cm INNER JOIN centre_access ca ON ca.CentreAccess = cm.CentreID Where ca.IsActive=1 and ca.EmployeeID = '" + employee_id + "' order by CentreName");
    }

    public static DataTable bindEmployeeCentrewise(int CentreID)
    {
        return StockReports.GetDataTable(" select concat(em.Title,' ',em.Name)EmployeeName,em.EmployeeID from employee_master em INNER JOIN centre_access ca ON ca.EmployeeID=em.EmployeeID Where ca.IsActive=1 and em.IsActive=1 and ca.CentreAccess=" + CentreID + "  group by em.EmployeeID order by em.Name ");

    }

    public static void bindCentre(CheckBoxList Centre, string employee_id, Button report)
    {
        DataTable dtData = dtbind_Centre(employee_id);
        if (dtData.Rows.Count > 0)
        {
            Centre.DataSource = dtData;
            Centre.DataTextField = "CentreName";
            Centre.DataValueField = "CentreID";
            Centre.DataBind();
            Centre.RepeatColumns = 6;
            foreach (ListItem li in Centre.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            report.Enabled = false;
        }
    }
    public static DataTable getDocTypeList(int i)
    {
        // 5 for Doc Department,1 doc Degree,3 Doc Specialization
        return StockReports.GetDataTable("SELECT ID,Name from type_master where TypeID =" + i + " order by Name");
    }
    public static void bindDocTypeList(DropDownList typeList, int docType, string type = "")
    {
        DataTable dtData = getDocTypeList(docType);
        if (dtData.Rows.Count > 0)
        {
            typeList.DataSource = dtData;
            typeList.DataTextField = "Name";
            typeList.DataValueField = "ID";
            typeList.DataBind();
            typeList.Items.Insert(0, new ListItem(type, "0"));
        }
    }

    public static void bindDistrict(DropDownList ddlObject, string countryID, string stateID)
    {
        DataTable dtData = LoadCacheQuery.loadDistrict(countryID, stateID);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "District";
            ddlObject.DataValueField = "DistrictID";
            ddlObject.DataBind();
            DataRow[] dr = dtData.Select("IsCurrent=1");
            if (dr.Length > 0)
            {
                ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByValue(dr[0]["DistrictID"].ToString()));
            }
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    public static void bindTaluk(DropDownList ddlObject, String districtID)
    {
        DataTable dtData = LoadCacheQuery.loadTaluk(districtID);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Taluka";
            ddlObject.DataValueField = "TalukaID";
            ddlObject.DataBind();
            DataRow[] dr = dtData.Select("IsCurrent=1");
            if (dr.Length > 0)
            {
                ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByText(dr[0]["TalukaID"].ToString()));
            }
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    public static void bindMedicineQuan(DropDownList ddlObject, String Type)
    {
        DataTable dtData = LoadCacheQuery.LoadMedicineQuantity(Type);
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "NAME";
            ddlObject.DataValueField = "Quantity";
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, "");
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }

    public static int notificationInsert(string employee_ID, int RoleID, int notificationID, string URL, string Message, string tableName, string ColumnName, string inputType, string UpdatedID, string DoctorID = "", string notificationDate = "", MySqlTransaction tnx = null, int dependentType = 0, string RoleIDConcat = "")
    {
        try
        {
            if (notificationDate == "")
                notificationDate = "0001-01-01";
            int CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
            if (tnx == null)
            {
                if (dependentType == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO notification_detail (EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)   ");
                    sb.Append(" SELECT EmployeeID,RoleID,'" + URL + "'," + notificationID + ",'" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + notificationDate + "'," + CentreID + " FROM notification_access  ");
                    sb.Append(" WHERE IsActive=1 AND notificationID=" + notificationID + " AND CentreID=" + CentreID + " ");
                    if (RoleID != 0 && (notificationID == 16 || notificationID == 29))
                        sb.Append(" AND RoleID='" + RoleID + "' ");
                    StockReports.ExecuteDML(sb.ToString());
                }
                else if (dependentType == 1)
                {
                    if (employee_ID != "")
                        StockReports.ExecuteDML("INSERT INTO notification_detail(EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)VALUES('" + employee_ID + "','" + RoleID + "','" + URL + "','" + notificationID + "','" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + Util.GetDateTime(notificationDate).ToString("yyyy-MM-dd") + "'," + CentreID + ")");

                    StockReports.ExecuteDML(" INSERT INTO notification_detail (EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)  " +
                      " SELECT EmployeeID,RoleID,'" + URL + "'," + notificationID + ",'" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + notificationDate + "'," + CentreID + " FROM notification_access WHERE IsActive=1 AND notificationID=" + notificationID + " AND employeeID !='" + employee_ID + "' AND CentreID=" + CentreID + "  ");

                }
                else if (dependentType == 2)
                {
                    StockReports.ExecuteDML("INSERT INTO notification_detail(EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)VALUES('" + employee_ID + "','" + RoleID + "','" + URL + "','" + notificationID + "','" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + Util.GetDateTime(notificationDate).ToString("yyyy-MM-dd") + "'," + CentreID + ")");
                }
            }
            else
            {
                if (dependentType == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO notification_detail (EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)  ");
                    sb.Append(" SELECT EmployeeID,RoleID,'" + URL + "'," + notificationID + ",'" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + notificationDate + "'," + CentreID + " FROM notification_access ");
                    sb.Append(" WHERE IsActive=1 AND notificationID=" + notificationID + "  ");
                    if (RoleIDConcat != "")
                        sb.Append(" AND RoleID NOT IN (" + RoleIDConcat + ")");
                    if (RoleID != 0 && (notificationID == 11 || notificationID == 28 || notificationID == 27 || notificationID == 26 || notificationID == 18 || notificationID == 31 || notificationID == 30))
                        sb.Append(" AND RoleID ='" + RoleID + "' ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
                }
                else if (dependentType == 1)
                {
                    if ((employee_ID == "") && (DoctorID != ""))
                        employee_ID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT EmployeeID FROM doctor_employee  WHERE  DoctorID='" + DoctorID + "' "));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO notification_detail(EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)VALUES('" + employee_ID + "','" + RoleID + "','" + URL + "','" + notificationID + "','" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + Util.GetDateTime(notificationDate).ToString("yyyy-MM-dd") + "'," + CentreID + ")");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO notification_detail (EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)  " +
                     " SELECT EmployeeID,RoleID,'" + URL + "'," + notificationID + ",'" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + notificationDate + "'," + CentreID + " FROM notification_access WHERE IsActive=1 AND notificationID=" + notificationID + " AND employeeID !='" + employee_ID + "' AND CentreID=" + CentreID + " ");
                }
                else if (dependentType == 2)
                {
                    if ((employee_ID == "") && (DoctorID != ""))
                        employee_ID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT EmployeeID FROM doctor_employee  WHERE  DoctorID='" + DoctorID + "' "));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO notification_detail(EmployeeID,RoleID,PagePath,NotificationID,Message,tableName,ColumnName,inputType,UpdatedID,notificationDate,CentreID)VALUES('" + employee_ID + "','" + RoleID + "','" + URL + "','" + notificationID + "','" + Message + "','" + tableName + "','" + ColumnName + "','" + inputType + "','" + UpdatedID + "','" + Util.GetDateTime(notificationDate).ToString("yyyy-MM-dd") + "'," + CentreID + ")");
                }
            }
            return 1;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }

    public static int updateNotification(string UpdatedID, string EmployeeID = "", string RoleID = "", int notificationID = 0, MySqlTransaction tnx = null, string InputType = "")
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE notification_detail SET IsView=1 WHERE UpdatedID='" + UpdatedID + "' ");
            if (notificationID != 0)
                sb.Append(" AND notificationID='" + notificationID + "'");
            if (InputType != "")
                sb.Append(" AND InputType='" + InputType + "'");
            if (EmployeeID != "")
                sb.Append(" AND EmployeeID='" + EmployeeID + "'");
            if (RoleID != "")
                sb.Append(" AND RoleID='" + RoleID + "'");
            if (tnx != null)
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());
            else
                StockReports.ExecuteDML(sb.ToString());
            return 1;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }

    public static void getCurrentDate(TextBox toDate, TextBox fromDate)
    {
        toDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        toDate.Attributes.Add("readOnly", "true");
        fromDate.Attributes.Add("readOnly", "true");
    }
    public static int chkDocumentDrive()
    {
        try
        {
            DirectoryInfo folder = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName);
            if (folder.Exists)
            {
                DirectoryInfo[] SubFolder = folder.GetDirectories(Resources.Resource.DocumentFolderName);
                if (SubFolder.Length == 0)
                {
                    var directory = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName);
                    if (directory.Exists == false)
                    {
                        directory.Create();
                    }
                }
                return 1;
            }
            else
            {
                return 0;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return 0;
        }
    }
    public static DirectoryInfo createDocumentFolder(string folderName, string subFolderName, string anotherSubFolderName = "")
    {
        try
        {
            var pathname = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\" + folderName);
            if (pathname.Exists == false)
                pathname.Create();
            pathname = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\" + folderName + "\\" + subFolderName);
            if (pathname.Exists == false)
                pathname.Create();
            if (anotherSubFolderName != "")
            {
                pathname = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\" + folderName + "\\" + subFolderName + "\\" + anotherSubFolderName);
                if (pathname.Exists == false)
                    pathname.Create();
            }
            return pathname;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static string IpAddress()
    {
        string IpAddress = "";
        if (string.IsNullOrEmpty(HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"]))
            IpAddress = HttpContext.Current.Request.UserHostAddress;
        else
            IpAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
        return IpAddress;
    }
    public static void bindEmployee(DropDownList ddlObject, string Type = "")
    {
        DataTable dtData = LoadEmployee();
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "Name";
            ddlObject.DataValueField = "EmployeeID";
            ddlObject.DataBind();
            if (Type != "")
                ddlObject.Items.Insert(0, new ListItem(Type, "0"));
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static string macAddress()
    {
        NetworkInterface[] nics = NetworkInterface.GetAllNetworkInterfaces();
        String sMacAddress = string.Empty;
        foreach (NetworkInterface adapter in nics)
        {
            if (sMacAddress == String.Empty)// only return MAC Address from first card
            {
                IPInterfaceProperties properties = adapter.GetIPProperties();
                sMacAddress = adapter.GetPhysicalAddress().ToString();
            }
        } return sMacAddress;
    }

    public static void bindDocGroup(DropDownList ddlObject, string Type = "")
    {
        DataTable dt = StockReports.GetDataTable("SELECT DocType,ID FROM DoctorGroup WHERE isActive=1");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlObject.DataSource = dt;
            ddlObject.DataTextField = "DocType";
            ddlObject.DataValueField = "ID";
            ddlObject.DataBind();
            if (Type != "")
                ddlObject.Items.Insert(0, new ListItem(Type, "0"));
        }

    }
    private static List<T> ConvertDataTable<T>(DataTable dt)
    {
        List<T> data = new List<T>();
        foreach (DataRow row in dt.Rows)
        {
            T item = GetItem<T>(row);
            data.Add(item);
        }
        return data;
    }
    private static T GetItem<T>(DataRow dr)
    {
        Type temp = typeof(T);
        T obj = Activator.CreateInstance<T>();

        foreach (DataColumn column in dr.Table.Columns)
        {
            foreach (PropertyInfo pro in temp.GetProperties())
            {
                if (pro.Name == column.ColumnName)
                    pro.SetValue(obj, dr[column.ColumnName], null);
                else
                    continue;
            }
        }
        return obj;
    }

    public static void fromDatetoDate(string TID, TextBox ucDate, TextBox toDate, CalendarExtender calucDate, CalendarExtender caltoDate)
    {
        AllQuery aq = new AllQuery();
        DateTime AdmitDate = Util.GetDateTime(aq.getAdmitDate(TID));
        DateTime dischargeDate = Util.GetDateTime(AllQuery.getDischargeDate(TID));
        if ((Util.GetString(dischargeDate.ToString("dd-MM-yyyy")) == "01-01-0001") || (Util.GetString(dischargeDate.ToString("dd-MM-yyyy")) == ""))
        {
            ucDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            toDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            caltoDate.EndDate = DateTime.Now;
            calucDate.EndDate = DateTime.Now;
        }
        else
        {
            ucDate.Text = dischargeDate.ToString("dd-MMM-yyyy");
            toDate.Text = dischargeDate.ToString("dd-MMM-yyyy");

            caltoDate.EndDate = Util.GetDateTime(dischargeDate.ToString("dd-MMM-yyyy"));
            calucDate.EndDate = Util.GetDateTime(dischargeDate.ToString("dd-MMM-yyyy"));
        }
        calucDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
        caltoDate.StartDate = Util.GetDateTime(AdmitDate.ToString("dd-MMM-yyyy"));
    }
    public static void BindPanelGroup(DropDownList ddlObject, string Type = "", CheckBoxList chklObject = null)
    {
        DataTable dtData = StockReports.GetDataTable("Select PanelGroupID,PanelGroup from f_panelgroup where active=1 order by PanelGroupID");
        if (dtData != null && dtData.Rows.Count > 0)
        {
            if (ddlObject != null)
            {
                ddlObject.DataSource = dtData;
                ddlObject.DataTextField = "PanelGroup";
                ddlObject.DataValueField = "PanelGroupID";
                ddlObject.DataBind();
                if (Type != "")
                    ddlObject.Items.Insert(0, new ListItem(Type, "0"));
            }
            else
            {
                chklObject.DataSource = dtData;
                chklObject.DataTextField = "PanelGroup";
                chklObject.DataValueField = "PanelGroupID";
                chklObject.DataBind();
            }
        }

    }

    public static void bindState(DropDownList ddlObject, string countryID)
    {
        DataTable dtData = LoadCacheQuery.loadState(Util.GetInt(countryID));
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlObject.DataSource = dtData;
            ddlObject.DataTextField = "StateName";
            ddlObject.DataValueField = "StateID";
            ddlObject.DataBind();
            DataRow[] dr = dtData.Select("IsCurrent=1");
            if (dr.Length > 0)
            {
                ddlObject.SelectedIndex = ddlObject.Items.IndexOf(ddlObject.Items.FindByValue(dr[0]["StateID"].ToString()));
            }
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
        }
    }
    public static void bindShareDoctorList(DropDownList ddlObject, int isPosted, string type = "")
    {
        string shareDate = string.Empty;
        string shareFrom = string.Empty;
        string shareTo = string.Empty;

        //shareDate = Util.GetString(StockReports.ExecuteScalar(" SELECT CONCAT(Share_From,'#',Share_To) FROM da_share_date WHERE PostShare=0 ORDER BY ID DESC LIMIT 1 "));
        shareDate = Util.GetString(StockReports.ExecuteScalar(" SELECT CONCAT(Share_From,'#',Share_To) FROM da_share_date ORDER BY ID DESC LIMIT 1 "));

        shareFrom = Util.GetString(shareDate.Split('#')[0]);
        shareTo = Util.GetString(shareDate.Split('#')[1]);

        if (shareFrom != "" && shareTo != "")
        {
            // string query = " SELECT DISTINCT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DocName FROM da_doctorsharestatus dss INNER JOIN doctor_master dm on dss.DoctorID=dm.DoctorID WHERE Share_From='" + shareFrom + "' and Share_To='" + shareTo + "' AND dss.IsPosted='" + isPosted + "' ORDER BY dm.Name ";
            //string query = " SELECT dm.DoctorID,CONCAT(dm.Title,' ',dm.Name)DocName  FROM doctor_master dm INNER JOIN (SELECT DISTINCT DoctorID FROM da_doctorsharestatus WHERE Share_From='" + shareFrom + "' AND Share_To='" + shareTo + "' AND IsPosted='" + isPosted + "' ) dss ON dm.DoctorID=dss.DoctorID ORDER BY dm.Name ";
           
           string query = " CALL `docacc_DoctorSharePostAndUnPostAndDoctor`("+ (isPosted==0?3:4) +",'"+ shareFrom +"','"+ shareTo +"',"+ HttpContext.Current.Session["CentreID"].ToString() +",0,'') ";
            
            DataTable dtDoctor = StockReports.GetDataTable(query);

            if (dtDoctor != null && dtDoctor.Rows.Count > 0)
            {
                ddlObject.DataSource = dtDoctor;
                ddlObject.DataTextField = "DocName";
                ddlObject.DataValueField = "DoctorID";
                ddlObject.DataBind();

                if (type != "")
                    ddlObject.Items.Insert(0, new ListItem(type, "0"));
            }
            else
            {
                ddlObject.DataSource = null;
                ddlObject.DataBind();
                ddlObject.Items.Insert(0, new ListItem("--No Data--", "0"));
            }
        }
        else
        {
            ddlObject.DataSource = null;
            ddlObject.DataBind();
            ddlObject.Items.Insert(0, new ListItem("--No Data--", "0"));
        }
    }



    public static DataTable GetItemRate()
    {

        return new DataTable();

    }
    public static DataTable BindLabRadioDepartment(String RoleID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT UPPER(ot.Name)Name,ot.ObservationType_ID FROM  observationtype_master ot INNER JOIN f_subcategorymaster sm ON ot.Description=sm.SubCategoryID  ");
        sb.Append("  INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID  AND cr.RoleID='" + RoleID + "'");

        sb.Append(" WHERE ot.IsActive=1 ORDER BY ot.Name ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
            return dt;
        else
            return null;
    }
    public static string CalcaluteDoctorShare(string LedgerTnxID, string ID, string ModuleType, string ShareType, MySqlTransaction Tranx = null, MySqlConnection con = null)
    {
        try
        {
            string status = string.Empty;
            if (ShareType == "HOSP")
            {
                if (ID == string.Empty)
                {
                    string[] ltd = LedgerTnxID.Split(',');
                    for (int i = 0; i < ltd.Length; i++)
                    {
                        if (Tranx == null)
                        {
                            int ltdID = Util.GetInt(StockReports.ExecuteScalar("SELECT ID FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTnxID='" + ltd[i] + "' "));
                            StockReports.ExecuteDML("DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + ltdID + "; ");
                            StockReports.ExecuteDML("CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + ltdID + "," + ModuleType + ",'" + ShareType + "');");
                            status = "1";
                        }
                        else
                        {
                            string str = "SELECT ID FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTnxID='" + ltd[i] + "' ";
                            int Result = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + Result + "; ");
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + Result + "," + ModuleType + ",'" + ShareType + "');");
                            status = "1";
                        }
                    }
                }
                else
                {
                    string[] ltd = ID.Split(',');
                    for (int i = 0; i < ltd.Length; i++)
                    {
                        if (Tranx == null)
                        {
                            StockReports.ExecuteDML("DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.ID=" + ltd[i] + "; ");
                            StockReports.ExecuteDML("CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + ltd[i] + "," + ModuleType + ",'" + ShareType + "');");
                            status = "1";
                        }
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE ds.* FROM f_docshare_transactiondetail ds WHERE ds.LedgerTnxID=" + ltd[i] + "; ");
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + ltd[i] + "," + ModuleType + ",'" + ShareType + "');");
                            status = "1";
                        }
                    }
                }
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "CALL `Insert_DoctorShare_At_ServiceBookingTime`(" + ID + "," + ModuleType + ",'" + ShareType + "');");
                status = "1";
            }
            return status;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    public string Alert(string message)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<script type = 'text/javascript'>");
        sb.Append("window.onload=function(){");
        sb.Append("myfunction('");
        sb.Append(message);
        sb.Append("')};");
        sb.Append("</script>");
        return sb.ToString();
    }

 public static DataTable loadPanelRoleWisePanelGroupWise(int IsCoverNote)
    {
        //IsCoverNote :-  1 : Panel Bind for Cover Note, 2 : Panel Bind for Invoice , 3 : Panel Bind for Cover Note in Master Screen , 4 : Panel Bind for Invoice in Master Screen 

        string PanelGroupIDs = Util.GetString(StockReports.ExecuteScalar(" SELECT IFNULL(r.`PanelGroupID`,'0') FROM f_centre_role_panelgroup_mapping r WHERE r.`RoleID`=" + HttpContext.Current.Session["RoleID"].ToString() + " AND r.`CentreID`=" + HttpContext.Current.Session["CentreID"].ToString() + " AND r.`isActive`=1 ORDER BY r.`ID` DESC  LIMIT 1 "));
        if (PanelGroupIDs == string.Empty)
            PanelGroupIDs = "0";

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT TRIM(Company_Name) AS Company_Name,if(" + IsCoverNote + "=2,CONCAT(pm.PanelID,'$',pm.CoverNote),pm.PanelID) as PanelID  FROM f_panel_master pm INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID where pm.Isactive=1 AND fcp.CentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' AND fcp.isActive=1 ");

        if (IsCoverNote != 3 && IsCoverNote != 4 && PanelGroupIDs != "0")
        {
            sb.Append(" and pm.PanelGroupID IN(" + PanelGroupIDs + ") ");
        }

        if (IsCoverNote == 1 || IsCoverNote == 3)
        {
            sb.Append(" and pm.CoverNote =1 ");
        }
        else if (IsCoverNote == 2 || IsCoverNote == 4)
        {
            sb.Append(" and pm.IsCash=0 ");
        }

        sb.Append("  ORDER BY Company_Name  ");
        DataTable dtPanel = StockReports.GetDataTable(sb.ToString());
        return dtPanel;
    }
	
	public static DataTable GetItemRateByType_ID(string Type_ID, string PanelID, string SubCategoryID)
 {
     DataTable Items = new DataTable();
     try
     {
         string RefCodeopd = StockReports.ExecuteScalar("SELECT ReferenceCodeOPD from f_panel_master where panelid='" + PanelID + "'");
         string strQuery = "Select IFNULL(RL.Rate,0)Rate,RL.RateListID,RL.ItemID,IFNULL(RL.FromDate,'')FromDate,  IFNULL(RL.IsTaxable,'')IsTaxable,IM.TypeName Item,RL.PanelID,IM.Type_ID,IM.ValidityPeriod,IM.SubCategoryID,rl.ScheduleChargeID from f_itemmaster im inner join f_ratelist rl on im.itemid = rl.itemid INNER JOIN f_rate_schedulecharges rsc ON rsc.PanelID = rl.PanelID AND rsc.IsDefault=1 and rsc.ScheduleChargeID=rl.ScheduleChargeID where im.subcategoryid='" + SubCategoryID + "' and im.type_id='" + Type_ID + "' and rl.panelid='" + RefCodeopd + "' and rl.iscurrent=1";
         return StockReports.GetDataTable(strQuery);

     }
     catch (Exception ex)
     {
         ClassLog cl = new ClassLog();
         cl.errLog(ex);
         return null;
     }
 }
}