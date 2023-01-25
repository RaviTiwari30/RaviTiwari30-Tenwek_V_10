using System;
using System.Data;
using System.Text;
using System.Web.UI;
using MySql.Data.MySqlClient;
using System.IO;
using System.Web;

public partial class Design_EDP_UserAuthorization : System.Web.UI.Page
{
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            MySqlConnection con = new MySqlConnection(Util.GetConString());
            if (ViewState["save"].ToString() == "1")
            {
                try
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("insert into userauthorization(");
                    sb.Append("RoleId,EmployeeID,IsEdit,IsReject,IsDiscount,MedItemEdit,d_IsEdit,d_IsReject,d_IsDiscount,BillChange,IsLabReject,");

                    sb.Append("IsFinalbillOpen,IsMedClear,EditQuot,PSetQuot,AppAmtAfterBill,PurchaseRequest,PurchaseOrder,Physical_Verification,IsDiscAfterBill,IsPlanDischarge,IsRoomClearance,IsPatientClearance,IsNurseClean,IsBillFreezed,ChangeSellingPrice,IsRefund,IsPostGRN,IsEditAfterPost,IsAllowedOriginalPrint,IsCanSettleBatch,CanViewRate,CanViewVitalPopUp,CanRefundAllAmount,CanShowCoPayment,CanViewAllUserCollection");
                    sb.Append(",CanEditEMGBilling,CanRejectEMGBilling,CanViewRatesEMGBilling,CanReleaseEMGPatient,CanCloseEMGBilling,CanEditCloseEMGBilling,CanReceivePatient,CanEditPurchaseOrder,CanEditMedicationRecord,CanApproveDoctorAllocation  ");
                    sb.Append(",CanIndentMedicalItems,CanIndentMedicalConsumables,CanChangePanel,CanEditBill,CanChangeRelation,CanChangePaymentDetails,CanUploadPanelDocuments, ");
                    //Any new Field should be appended at this position before Creator_ID

                    sb.Append("IsCanLab,IsCanRadio,IsCanPro,IsCanCon,IsCanPack,IsCanOther,CanUpdateBillNarration,IsBlood ");
                    //
                    sb.Append(",CanFilanisePersonnelForm,CanRejectPersonnelForm,CanConductInterView,CanEnterInterViewRound,CanAcknowledgeInterView,CanCloseInterViewProcess,CanEditCandidateMaster ");

                    sb.Append(",Creator_id,Creator_date) values ");
                    sb.Append(" (" + ddlDepartment.SelectedValue + ", '" + ddlEmployee.SelectedValue + "' ");

                    for (int i = 0; i < chkAuthority.Items.Count; i++)
                    {
                        if (chkAuthority.Items[i].Selected)
                        {
                            switch (chkAuthority.Items[i].Value)
                            {
                                case "IsEdit":
                                case "IsReject":
                                case "IsDiscount":
                                case "MedItemEdit":
                                case "d_IsEdit":
                                case "d_IsReject":
                                case "d_IsDiscount":
                                case "BillChange":
                                case "IsLabReject":
                                case "IsFinalbillOpen":
                                case "IsMedClear":
                                case "EditQuot":
                                case "PSetQuot":
                                case "AppAmtAfterBill":
                                case "PurchaseRequest":
                                case "PurchaseOrder":
                                case "Physical_Verification":
                                case "IsDiscAfterBill":
                                case "IsPlanDischarge":
                                case "IsRoomClearance":
                                case "IsPatientClearance":
                                case "IsNurseClean":
                                case "IsBillFreezed":
                                case "ChangeSellingPrice":
                                case "IsRefund":
                                case "IsPostGRN":
                                case "IsEditAfterPost":
                                case "IsAllowedOriginalPrint":
                                case "IsCanSettleBatch":
                                case "CanViewRate":
                                case "CanViewVitalPopUp":
                                case "CanRefundAllAmount":
                                case "CanShowCoPayment":
                                case "CanViewAllUserCollection":
                                case "CanEditEMGBilling":
                                case "CanRejectEMGBilling":
                                case "CanViewRatesEMGBilling":
                                case "CanReleaseEMGPatient":
                                case "CanCloseEMGBilling":
                                case "CanEditCloseEMGBilling":
                                case "CanReceivePatient":
                                case "CanEditPurchaseOrder":
                                case "CanEditMedicationRecord":
                                case "CanApproveDoctorAllocation":
                                case "CanIndentMedicalItems":
                                case "CanIndentMedicalConsumables":
                                case "CanChangePanel":
                                case "CanEditBill":
                                case "CanChangeRelation":
                                case "CanChangePaymentDetails":
                                case "CanUploadPanelDocuments":
                                case "IsCanLab":
                                case "IsCanRadio":
                                case "IsCanPro":
                                case "IsCanCon":
                                case "IsCanPack":
                                case "IsCanOther":
                                case "CanUpdateBillNarration":  
                                case"IsBlood":
 case "CanFilanisePersonnelForm":
                                case "CanRejectPersonnelForm":
                                case "CanConductInterView":
                                case "CanEnterInterViewRound":
                                case "CanAcknowledgeInterView":
                                case "CanCloseInterViewProcess":
                                case "CanEditCandidateMaster":
                                    sb.Append(",1");
                                    break;
                                default:
                                    break;


                            }
                        }
                        else
                            sb.Append(",0");
                    }

                    sb.Append(",'" + ViewState["UserID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "' )");

                    int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

                    DropCache();//
                    BindAuthorityType();
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    con.Close();
                    con.Dispose();
                }
            }
            else
            {
                try
                {
                    string IsDiscount = "0", IsReject = "0", IsEdit = "0", BillChange = "0";
                    string d_IsDiscount = "0", d_IsReject = "0", d_IsEdit = "0", MedItemEdit = "0";
                    string IsLabReject = "0", IsFinalbillOpen = "0", IsMedClear = "0";
                    string EditQuot = "0", PSetQuot = "0", AppAmtAfterBill = "0", PurchaseRequest = "0", PurchaseOrder = "0", Physical_Verification = "0", IsDiscAfterBill = "0";
                    string IsPlanDischarge = "0", IsRoomClearance = "0", IsPatientClearance = "0", IsNurseClean = "0", IsBillFreezed = "0", ChangeSellingPrice = "0", IsRefund = "0";
                    string IsPostGRN = "0", IsEditAfterPost = "0", IsAllowedOriginalPrint = "0";
                    string IsCanSettleBatch = "0", CanViewRate = "0", CanViewVitalPopUp = "0", CanRefundAllAmount = "0", CanShowCoPayment = "0", CanViewAllUserCollection = "0";
                    string CanEditEMGBilling = "0", CanRejectEMGBilling = "0", CanViewRatesEMGBilling = "0", CanReleaseEMGPatient = "0", CanCloseEMGBilling = "0", CanReceivePatient = "0", CanEditPurchaseOrder = "0", CanEditMedicationRecord = "0", CanApproveDoctorAllocation = "0";
                    string CanEditCloseEMGBilling = "0", CanIndentMedicalItems = "0", CanIndentMedicalConsumables = "0", CanChangePanel = "0", CanEditBill = "0", CanChangeRelation = "0", CanChangePaymentDetails = "0", CanUploadPanelDocuments = "0";

                    string IsCanLab = "0", IsCanRadio = "0", IsCanPro = "0", IsCanCon = "0", IsCanPack = "0", IsCanOther = "0", CanUpdateBillNarration = "0", IsBlood = "0";
                    string CanFilanisePersonnelForm = "0", CanRejectPersonnelForm = "0", CanConductInterView = "0", CanEnterInterViewRound = "0", CanAcknowledgeInterView = "0", CanCloseInterViewProcess = "0", CanEditCandidateMaster = "0";



                    for (int i = 0; i < chkAuthority.Items.Count; i++)
                    {
                        if (chkAuthority.Items[i].Selected)
                        {
                            if (chkAuthority.Items[i].Value == "IsDiscount")
                                IsDiscount = "1";
                            else if (chkAuthority.Items[i].Value == "IsReject")
                                IsReject = "1";
                            else if (chkAuthority.Items[i].Value == "IsEdit")
                                IsEdit = "1";
                            else if (chkAuthority.Items[i].Value == "d_IsDiscount")
                                d_IsDiscount = "1";
                            else if (chkAuthority.Items[i].Value == "d_IsReject")
                                d_IsReject = "1";
                            else if (chkAuthority.Items[i].Value == "d_IsEdit")
                                d_IsEdit = "1";
                            else if (chkAuthority.Items[i].Value == "BillChange")
                                BillChange = "1";
                            else if (chkAuthority.Items[i].Value == "MedItemEdit")
                                MedItemEdit = "1";
                            else if (chkAuthority.Items[i].Value == "IsLabReject")
                            {
                                IsLabReject = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsFinalbillOpen")
                            {
                                IsFinalbillOpen = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsMedClear")
                            {
                                IsMedClear = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "EditQuot")
                            {
                                EditQuot = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "PSetQuot")
                            {
                                PSetQuot = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "AppAmtAfterBill")
                            {
                                AppAmtAfterBill = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "PurchaseRequest")
                            {
                                PurchaseRequest = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "PurchaseOrder")
                            {
                                PurchaseOrder = "1";
                            }

                            else if (chkAuthority.Items[i].Value == "Physical_Verification")
                            {
                                Physical_Verification = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsDiscAfterBill")
                            {
                                IsDiscAfterBill = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsPlanDischarge")
                            {
                                IsPlanDischarge = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsRoomClearance")
                            {
                                IsRoomClearance = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsPatientClearance")
                            {
                                IsPatientClearance = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsNurseClean")
                            {
                                IsNurseClean = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsBillFreezed")
                            {
                                IsBillFreezed = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "ChangeSellingPrice")
                            {
                                ChangeSellingPrice = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsRefund")
                            {
                                IsRefund = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsPostGRN")
                            {
                                IsPostGRN = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsEditAfterPost")
                            {
                                IsEditAfterPost = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsAllowedOriginalPrint")
                            {
                                IsAllowedOriginalPrint = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsCanSettleBatch")
                            {
                                IsCanSettleBatch = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanViewRate")
                            {
                                CanViewRate = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanViewVitalPopUp")
                            {
                                CanViewVitalPopUp = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanRefundAllAmount")
                            {
                                CanRefundAllAmount = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanShowCoPayment")
                            {
                                CanShowCoPayment = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanViewAllUserCollection")
                            {
                                CanViewAllUserCollection = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanEditEMGBilling")
                            {
                                CanEditEMGBilling = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanRejectEMGBilling")
                            {
                                CanRejectEMGBilling = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanViewRatesEMGBilling")
                            {
                                CanViewRatesEMGBilling = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanReleaseEMGPatient")
                            {
                                CanReleaseEMGPatient = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanCloseEMGBilling")
                            {
                                CanCloseEMGBilling = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanReceivePatient")
                            {
                                CanReceivePatient = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanEditPurchaseOrder")
                            {
                                CanEditPurchaseOrder = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanEditMedicationRecord")
                            {
                                CanEditMedicationRecord = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanEditCloseEMGBilling")
                            {
                                CanEditCloseEMGBilling = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanApproveDoctorAllocation")
                            {
                                CanApproveDoctorAllocation = "1";
                            }

                            else if (chkAuthority.Items[i].Value == "CanIndentMedicalItems")
                            {
                                CanIndentMedicalItems = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanIndentMedicalConsumables")
                            {
                                CanIndentMedicalConsumables = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanChangePanel")
                            {
                                CanChangePanel = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanEditBill")
                            {
                                CanEditBill = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanChangeRelation")
                            {
                                CanChangeRelation = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanChangePaymentDetails")
                            {
                                CanChangePaymentDetails = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanUploadPanelDocuments")
                            {
                                CanUploadPanelDocuments = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsCanLab")
                            {
                                IsCanLab = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsCanRadio")
                            {
                                IsCanRadio = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsCanPro")
                            {
                                IsCanPro = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsCanCon")
                            {
                                IsCanCon = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsCanPack")
                            {
                                IsCanPack = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsCanOther")
                            {
                                IsCanOther = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanUpdateBillNarration")
                            {
                                CanUpdateBillNarration = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "IsBlood")
                            {
                                IsBlood = "1";
                            }
   else if (chkAuthority.Items[i].Value == "CanFilanisePersonnelForm")
                            {
                                CanFilanisePersonnelForm = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanRejectPersonnelForm")
                            {
                                CanRejectPersonnelForm = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanConductInterView")
                            {
                                CanConductInterView = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanEnterInterViewRound")
                            {
                                CanEnterInterViewRound = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanAcknowledgeInterView")
                            {
                                CanAcknowledgeInterView = "1";
                            }
                            else if (chkAuthority.Items[i].Value == "CanCloseInterViewProcess")
                            {
                                CanCloseInterViewProcess = "1";
                            }

                            else if (chkAuthority.Items[i].Value == "CanEditCandidateMaster")
                            {
                                CanEditCandidateMaster = "1";
                            }
                        }
                    }

                    StringBuilder sb = new StringBuilder();
                    sb.Append("update userauthorization set UpdatedBy='" + Session["ID"].ToString() + "',UpdatedDate=now(), IsEdit=" + IsEdit + ",IsReject=" + IsReject + "," +
                        "IsDiscount=" + IsDiscount + ",MedItemEdit=" + MedItemEdit + "," +
                        "d_IsEdit=" + d_IsEdit + ",d_IsReject=" + d_IsReject + "," +
                        "d_IsDiscount=" + d_IsDiscount + ",BillChange=" + BillChange + "," +
                        "Creator_id='" + Session["ID"] + "'," +
                        "Creator_date='" + DateTime.Now.ToString("yyyy-MM-dd") + "' ," +
                        "IsLabReject=" + IsLabReject + ",IsFinalbillOpen=" + IsFinalbillOpen + "," +
                        "IsMedClear=" + IsMedClear + ", EditQuot=" + EditQuot + "," +
                        "PSetQuot=" + PSetQuot + ", AppAmtAfterBill=" + AppAmtAfterBill + ",PurchaseRequest='" + PurchaseRequest + "',PurchaseOrder='" + PurchaseOrder + "',Physical_Verification='" + Physical_Verification + "',IsDiscAfterBill='" + IsDiscAfterBill + "', " +
                        "IsPlanDischarge=" + IsPlanDischarge + ",IsRoomClearance=" + IsRoomClearance + ",IsPatientClearance=" + IsPatientClearance + ",IsNurseClean=" + IsNurseClean + ",IsBillFreezed=" + IsBillFreezed + " ,ChangeSellingPrice='" + ChangeSellingPrice + "', " + "IsRefund='" + IsRefund + "' " +
                        ",IsPostGRN='" + IsPostGRN + "',IsEditAfterPost='" + IsEditAfterPost + "',IsAllowedOriginalPrint='" + IsAllowedOriginalPrint + "',IsCanSettleBatch='" + IsCanSettleBatch + "',CanViewRate='" + CanViewRate + "',CanViewVitalPopUp='" + CanViewVitalPopUp + "',CanRefundAllAmount='" + CanRefundAllAmount + "',CanShowCoPayment='" + CanShowCoPayment + "',CanViewAllUserCollection='" + CanViewAllUserCollection + "' " +
                        ",CanEditEMGBilling='" + CanEditEMGBilling + "',CanRejectEMGBilling='" + CanRejectEMGBilling + "',CanViewRatesEMGBilling='" + CanViewRatesEMGBilling + "',CanReleaseEMGPatient='" + CanReleaseEMGPatient + "',CanCloseEMGBilling='" + CanCloseEMGBilling + "',  " +
                        " CanReceivePatient=" + CanReceivePatient + " " +
                        ",CanEditPurchaseOrder=" + CanEditPurchaseOrder + " ,CanEditMedicationRecord =" + CanEditMedicationRecord + ",CanEditCloseEMGBilling=" + CanEditCloseEMGBilling + ",CanApproveDoctorAllocation=" + CanApproveDoctorAllocation + " ,CanIndentMedicalItems=" + CanIndentMedicalItems + " ,CanIndentMedicalConsumables=" + CanIndentMedicalConsumables + " " +
                       ",CanChangePanel=" + CanChangePanel + ",CanEditBill=" + CanEditBill + ",CanChangeRelation=" + CanChangeRelation + ",CanChangePaymentDetails=" + CanChangePaymentDetails + ",CanUploadPanelDocuments=" + CanUploadPanelDocuments + " " +

                         ",IsCanLab=" + IsCanLab + ",IsCanRadio=" + IsCanRadio + ",IsCanPro=" + IsCanPro + ",IsCanCon=" + IsCanCon + ",IsCanPack=" + IsCanPack + ",IsCanOther=" + IsCanOther + ",CanUpdateBillNarration=" + CanUpdateBillNarration + ",IsBlood=" + IsBlood + " " +
                          ",CanFilanisePersonnelForm='" + CanFilanisePersonnelForm + "',CanRejectPersonnelForm='" + CanRejectPersonnelForm + "',CanConductInterView='" + CanConductInterView + "',CanEnterInterViewRound='" + CanEnterInterViewRound + "',CanAcknowledgeInterView='" + CanAcknowledgeInterView + "',CanCloseInterViewProcess='" + CanCloseInterViewProcess + "',CanEditCandidateMaster='" + CanEditCandidateMaster + "'  " +
                       "where  RoleId=" + ddlDepartment.SelectedValue + " " +
                        "and EmployeeID= '" + ddlEmployee.SelectedValue + "'");
                    int result = MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                    con.Close();
                    con.Dispose();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);

                    DropCache();//
                    BindAuthorityType();
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    con.Close();
                    con.Dispose();
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void DropCache()//
    {
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/OPDServiceBookingControls_" + ddlDepartment.SelectedValue + "_" + HttpContext.Current.Session["ID"].ToString() + ".txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/OPDServiceBookingControls_" + ddlDepartment.SelectedValue + "_" + HttpContext.Current.Session["ID"].ToString() + ".txt"));
        }
    }

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindEmployee();
        BindAuthorityType();
    }

    protected void ddlEmployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAuthorityType();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRole();
            BindEmployee();
            BindAuthorityType();
            ViewState["UserID"] = Session["ID"].ToString();
        }
    }

    private void BindAuthorityType()
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        string str = "SELECT * FROM userauthorization WHERE RoleId=" + ddlDepartment.SelectedValue + " and EmployeeID='" + ddlEmployee.SelectedValue + "' order by Id desc limit 1";
        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];
        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataColumn dc in dt.Columns)
            {
                if (dt.Rows[0][dc.ColumnName].ToString() == "1")
                {
                    if (chkAuthority.Items.FindByValue(dc.ColumnName) != null)
                        chkAuthority.Items.FindByValue(dc.ColumnName).Selected = true;
                }
                else
                {
                    if (chkAuthority.Items.FindByValue(dc.ColumnName) != null)
                        chkAuthority.Items.FindByValue(dc.ColumnName).Selected = false;
                }
            }
            btnSave.Text = "Update";
            ViewState["save"] = "0";
        }
        else
        {
            foreach (DataColumn dc in dt.Columns)
            {
                if (chkAuthority.Items.FindByValue(dc.ColumnName) != null)
                    chkAuthority.Items.FindByValue(dc.ColumnName).Selected = false;
            }
            ViewState["save"] = "1";
        }
    }

    private void BindEmployee()
    {
        string str = "SELECT DISTINCT(em.Name),em.EmployeeID FROM employee_master em INNER JOIN f_login lo ON lo.EmployeeID=em.EmployeeID WHERE lo.RoleID='" + ddlDepartment.SelectedValue + "' AND  em.IsActive=1 AND lo.Active=1 ORDER BY NAME";
        DataTable dt = StockReports.GetDataTable(str);
        ddlEmployee.DataSource = dt;
        ddlEmployee.DataTextField = "Name";
        ddlEmployee.DataValueField = "EmployeeID";
        ddlEmployee.DataBind();
    }

    private void BindRole()
    {
        string str = "select id,rolename from f_rolemaster where active=1 order by rolename ";
        DataTable dt = StockReports.GetDataTable(str);
        ddlDepartment.DataSource = dt;
        ddlDepartment.DataTextField = "rolename";
        ddlDepartment.DataValueField = "id";
        ddlDepartment.DataBind();
        ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByText("Billing"));
    }
}