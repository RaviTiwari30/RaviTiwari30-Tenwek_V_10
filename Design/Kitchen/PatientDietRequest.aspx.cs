using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Kitchen_PatientDietRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    if (!IsPostBack)
        {
            
        AllLoadData_IPD.bindCaseType(ddlWard, "Select", 0);
        AllLoadData_Diet.bindDietTime(ddlDietTiming, "Select");
        bindFloor();
        txtDate.Attributes.Add("readOnly", "readOnly");
        txtDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        //ViewState["DietDefault"]=  (StockReports.ExecuteScalar("Select DietID From diet_DietType_master where IsActive='1' and IsDefault='1' "));
            
        }
    }
    private void bindFloor()
    {
        DataTable dt = All_LoadData.LoadFloor();
        if (dt.Rows.Count > 0)
        {
            ddlFloor.DataSource = dt;
            ddlFloor.DataTextField = "NAME";
            ddlFloor.DataValueField = "NAME";
            ddlFloor.DataBind();
            ddlFloor.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    private void BindDietType(string IsPanelApproved)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT DietID,NAME FROM diet_DietType_master WHERE Isactive='1' ");
        if (IsPanelApproved == "0" || IsPanelApproved == "1")
        {
            sb.Append("AND  IsPanelApproved='" + IsPanelApproved + "'");
        }
        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        if (dtData != null && dtData.Rows.Count > 0 )
        {
            ddlDietType1.DataSource = dtData;
            ddlDietType1.DataTextField = "NAME";
            ddlDietType1.DataValueField = "DietID";
            ddlDietType1.DataBind();

            ddlDietType1.Items.Insert(0, new ListItem("--Select--"));
        }
        else
        {
            ddlDietType1.DataSource = null;
            ddlDietType1.DataBind();
        }

    }
    private void BindMenuDDL()
    {

        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT DietMenuID,NAME FROM diet_Menu_master WHERE IsActive='1' ");

        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        if (dtData != null && dtData.Rows.Count > 0)
        {
            ddlMenu1.DataSource = dtData;
            ddlMenu1.DataTextField = "NAME";
            ddlMenu1.DataValueField = "DietMenuID";
            ddlMenu1.DataBind();

            ddlMenu1.Items.Insert(0, new ListItem("--Select--"));
        }
        else
        {
            ddlMenu1.DataSource = null;
            ddlMenu1.DataBind();
        }
    }

    private void BindSubDietType(string diettype)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT dsm.SubDietID,dsm.NAME FROM diet_subdiettype_master dsm ");
        sb.Append(" INNER JOIN diet_Map_Type_SubType dmts ON dmts.SubDietID = dsm.SubDietID WHERE dsm.IsActive='1' ");
        if (diettype != "" && diettype != "0")
        {
            sb.Append(" AND dmts.DietID= '" + diettype + "' ");
        }

        DataTable dtData = StockReports.GetDataTable(sb.ToString());
        if (dtData != null && dtData.Rows.Count > 0 )
        {
            ddlSubDietType1.DataSource = dtData;
            ddlSubDietType1.DataTextField = "NAME";
            ddlSubDietType1.DataValueField = "SubDietID";
            ddlSubDietType1.DataBind();

            ddlSubDietType1.Items.Insert(0, new ListItem("--Select--"));
        }
        else
        {
            ddlSubDietType1.Items.Clear();
            ddlSubDietType1.DataSource = null;
            ddlSubDietType1.DataBind();
            ddlSubDietType1.Items.Insert(0, new ListItem("--Select--"));
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
    }
    protected void ddlDietType1_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubDietType(ddlDietType1.SelectedValue);
    
    }
    [WebMethod]
    public static string dietSearch(string IPDCaseTypeID, string dietTiming, string dietDate, string floor,string isPrivate)
        {
        DataTable timeDT = StockReports.GetDataTable("SELECT CONCAT('" + Convert.ToDateTime(dietDate).ToString("yyyy-MM-dd") + "',' ', TIME_FORMAT(FromTime,'%H:%i %p'))RequestDateTime,IFNULL(OrderBefore,0) AS OrderBefore FROM diet_timing WHERE ID='" + dietTiming + "'");

        DateTime CanRequestDateTime = Convert.ToDateTime(timeDT.Rows[0]["RequestDateTime"]).AddHours(-Convert.ToInt16(timeDT.Rows[0]["OrderBefore"]));
        string OrderTime = "";
        if (DateTime.Now > CanRequestDateTime)
            {
            OrderTime = "1";
            }
        //dpdr.IsFreeze
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT (Select If(pp.IsPrivateDiet='1','Private','Normal') from f_panel_master pp where PanelID=pmh.PanelID)IsPrivate,(SELECT NAME as Room FROM `room_master` WHERE roomId=pip.RoomID)Ward,(Select Company_Name from f_panel_master where PanelID=pmh.PanelID)Panel,pip.PatientID,pmh.TransNo AS IPDNo,pip.TransactionID,CONCAT(pm.Title, ' ', pm.PName) AS PName, ");
        sb.Append(" IFNULL(dpdr.ID,0) requestID,IFNULL(IF(ISNULL(fpd.SubDietID),dpdr.SubDietID,fpd.SubDietID),'') AS SubDietID,IF(ISNULL(fpd.DietMenuID) OR fpd.DietMenuID=0,dpdr.DietMenuID, ");
        sb.Append(" fpd.DietMenuID) AS DietMenuID,IF(ISNULL(fpd.Remarks),dpdr.Remarks,fpd.Remarks) AS Remarks,dpdr.IsFreeze,dpdr.IsIssued,dpdr.IsReceived,IFNUll(fpd.ID,'') AS FixID,");
        sb.Append(" IFNULL(IF(ISNULL(fpd.`DietID`),dpdr.DietID,fpd.DietID),'') AS DietID ,pip.IPDCaseTypeID,pip.RoomID,pip.PanelID,'" + OrderTime + "' OrderTime, ");

        sb.Append(" IFNULL(dadr.ID,0)AttnRequestID,IFNULL(dadr.DietID,'')AttnDietID,IFNULL(dadr.SubDietID,'')AttnSubDietID,IFNULL(dadr.DietMenuID,'')AttnDietMenuID,IFNULL(dadr.DietTimeID,'')AttnDietTimeID, ");
        sb.Append(" IFNULL(dadr.IsFreeze,0)AttnIsFreeze,IFNULL(dadr.IsIssued,0)AttnIsIssued,IFNULL(dadr.IsReceived,0)AttnIsReceived,IFNULL(dadr.Remarks,'')AttnRemarks ");

        sb.Append("  FROM patient_ipd_profile pip  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`TransactionID`= pip.`TransactionID` and pmh.CentreID="+ Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) +"  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.PatientID=pip.PatientID INNER JOIN room_master rm ON rm.RoomId=pip.RoomID AND pip.IPDCaseTypeID=rm.IPDCaseTypeID ");
        sb.Append(" INNER JOIN f_panel_master pp ON pp.PanelID=pmh.PanelID ");
        sb.Append(" LEFT JOIN diet_fix_patient_diet fpd ON fpd.TransactionID = pip.TransactionID AND fpd.DietTimeID='" + dietTiming + "'");

        sb.Append(" LEFT JOIN diet_patient_diet_request dpdr ON dpdr.TransactionID=pip.TransactionID AND DATE(dpdr.Requestdate)='" + Util.GetDateTime(dietDate).ToString("yyyy-MM-dd") + "' AND dpdr.DietTimeID='" + dietTiming + "'");

        sb.Append(" LEFT JOIN diet_attendent_diet_request dadr ON  pmh.`TransactionID`=dadr.TransactionID AND DATE(dadr.Requestdate)='" + Util.GetDateTime(dietDate).ToString("yyyy-MM-dd") + "' AND dadr.DietTimeID='" + dietTiming + "'  ");
      
        sb.Append(" WHERE pip.Status='IN' ");
        if (isPrivate == "1")
        {
            sb.Append(" and pp.IsPrivateDiet='1' ");

        }
        else if(isPrivate == "0")
        {
            sb.Append(" and pp.IsPrivateDiet='0' ");
        
        }
        if (IPDCaseTypeID != "0")
            sb.Append(" AND pip.IPDCaseTypeID='" + IPDCaseTypeID + "'");
        if(floor !="0")
            sb.Append(" AND rm.Floor='" + floor + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
        }

    [WebMethod]
    public static string getComponentAttendent(string dietTimeID, string subDietID, string menuID, string IPDCaseType_ID, string panelID, string TID, string Room_ID, string IsFreeze, string Patient_ID, string RequestDate, string patientType)
    {
        string ReferPanelIPD = StockReports.ExecuteScalar("SELECT ReferenceCode FROM f_panel_master WHERE PanelID='" + panelID + "'");
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL(dpd.ID,0)PatComDetail,dmdc.ComponentName,IFNULL(frl.Rate,0)Rate,IFNULL(frl.ID,0)RateListID,dcm.ItemID,dcm.ComponentID,dmdc.Qty,dcm.Type,IFNULL(dcm.Unit,'')Unit,IFNULL(dcm.Calories,'')Calories,IFNULL(dcm.Protein,'')Protein,IFNULL(dcm.Sodium,'')Sodium,IFNULL(dcm.SaturatedFat,'')SaturatedFat, ");
        sb.Append(" IFNULL(dcm.T_Fat,'')T_Fat,IFNULL(Calcium,'')Calcium,IFNULL(Iron,'')Iron,IFNULL(zinc,'')zinc,'" + TID + "' Transaction_ID,'" + IPDCaseType_ID + "' IPDCaseTypeID ,'" + Room_ID + "' Room_ID,'" + IsFreeze + "'IsFreeze ,'" + Patient_ID + "' Patient_ID, ");
        sb.Append(" dmdc.DietTimeID dietTimeID,dmdc.SubDietID,dmdc.DietMenuID,dmdc.DietID,'" + panelID + "' AS `PanelID`,'" + patientType + "' AS `PatientType`,IFNULL(dpd.RequestedID,'')RequestedID FROM diet_map_diet_component dmdc ");
        sb.Append(" INNER JOIN diet_component_master dcm ON dcm.ComponentID=dmdc.ComponentID ");
        sb.Append(" LEFT JOIN f_ratelist_ipd frl ON frl.ItemID=dcm.ItemID AND  IPDcaseTypeID='" + IPDCaseType_ID + "' AND PanelID='" + ReferPanelIPD + "' AND IsCurrent=1 ");
        sb.Append(" LEFT JOIN diet_attendent_component_detail dpd ON dpd.ComponentID=dcm.ComponentID AND dpd.Transaction_ID='" + TID + "' AND dpd.IsActive=1 AND dpd.dietTimeID='" + dietTimeID + "'  AND DATE(dpd.CreatedDate)='" + Util.GetDateTime(RequestDate).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" WHERE dmdc.SubDietID='" + subDietID + "' AND dmdc.DietTimeID='" + dietTimeID + "' ");

        if (menuID != "")
        {
            sb.Append(" AND dmdc.DietMenuID='" + menuID + "' ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public static string getComponent(string dietTimeID, string subDietID, string menuID, string IPDCaseTypeID, string panelID, string TID, string Room_ID, string IsFreeze, string PatientID, string RequestDate)
    {
        string ReferPanelIPD = StockReports.ExecuteScalar("SELECT ReferenceCode FROM f_panel_master WHERE PanelID=" + panelID + " ");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT '0' as HideSave,dpd.`RequestedID`,IFNULL(dpd.ID,0)PatComDetail,dmdc.ComponentName,IFNULL(frl.Rate,0)Rate,IFNULL(frl.ID,0)RateListID,dcm.ItemID,dcm.ComponentID,dmdc.Qty,dcm.Type,IFNULL(dcm.Unit,'')Unit,IFNULL(dcm.Calories,'')Calories,IFNULL(dcm.Protein,'')Protein,IFNULL(dcm.Sodium,'')Sodium,IFNULL(dcm.SaturatedFat,'')SaturatedFat, ");
        sb.Append(" IFNULL(dcm.T_Fat,'')T_Fat,IFNULL(Calcium,'')Calcium,IFNULL(Iron,'')Iron,IFNULL(zinc,'')zinc,'" + TID + "' TransactionID,'" + IPDCaseTypeID + "' IPDCaseTypeID ,'" + Room_ID + "' Room_ID,'" + IsFreeze + "'IsFreeze ,'" + PatientID + "' PatientID, ");
        sb.Append(" dmdc.DietTimeID dietTimeID,dmdc.SubDietID,dmdc.DietMenuID,dmdc.DietID FROM diet_map_diet_component dmdc ");
        sb.Append(" INNER JOIN diet_component_master dcm ON dcm.ComponentID=dmdc.ComponentID ");
        sb.Append(" LEFT JOIN f_ratelist_ipd frl ON frl.ItemID=dcm.ItemID ");
        if(IPDCaseTypeID!="")
        {
        sb.Append(" AND  IPDcaseTypeID='" + IPDCaseTypeID + "'  ");
        }
        sb.Append(" AND PanelID=" + ReferPanelIPD + " AND IsCurrent=1 ");
        sb.Append(" LEFT JOIN diet_patient_Component_Detail dpd ON dpd.ComponentID=dcm.ComponentID ");
        if (TID != "")
        {
            sb.Append(" AND dpd.TransactionID='" + TID + "' ");
        }
        sb.Append(" AND dpd.IsActive=1 AND dpd.dietTimeID='" + dietTimeID + "'  ");
        if (RequestDate != "")
        {
            sb.Append(" AND DATE(dpd.CreatedDate)='" + Util.GetDateTime(RequestDate).ToString("yyyy-MM-dd") + "' ");
        }
        sb.Append(" WHERE  dmdc.DietTimeID='" + dietTimeID + "'  ");
        sb.Append(" AND dmdc.DietMenuID='" + menuID + "' AND dmdc.SubDietID='" + subDietID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public static string saveComponent1(List<dietComponent> ComponentDetail)
    {
        int len = ComponentDetail.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                if (ComponentDetail[0].patientRequestedID != 0)
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE pdr.*,pdc.* FROM diet_patient_diet_request pdr INNER JOIN diet_patient_Component_Detail pdc ON pdr.ID=pdc.RequestedID WHERE pdr.ID='" + ComponentDetail[0].patientRequestedID + "' ");
                }
                //  MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM diet_patient_diet_request WHERE TransactionID='" + ComponentDetail[0].TransactionID + "' AND DATE(RequestDate)='" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "' AND DietTimeID='" + ComponentDetail[0].DietTimeID + "'");
                //  MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE  diet_patient_Component_Detail SET IsActive=1 WHERE TransactionID='" + ComponentDetail[0].TransactionID + "' AND DATE(RequestDate)='" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "' AND DietTimeID='" + ComponentDetail[0].DietTimeID + "'");


                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO diet_patient_diet_request(TransactionID,SubDietID,DietMenuID,DietTimeID,Remarks,EnterBy,DietID,IPDCaseTypeID,RoomID,RequestDate)");
                sb.Append(" VALUES ('" + ComponentDetail[0].TransactionID + "','" + ComponentDetail[0].SubDietID + "','" + ComponentDetail[0].DietMenuID + "', ");
                sb.Append(" '" + ComponentDetail[0].DietTimeID + "','','" + HttpContext.Current.Session["ID"] + "','" + ComponentDetail[0].DietID + "','" + ComponentDetail[0].IPDCaseTypeID + "', ");
                sb.Append(" " + ComponentDetail[0].RoomID + ",'" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "')");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());


                int RequestedID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT MAX(ID) FROM diet_patient_diet_request"));

                Notification_Insert.notificationInsert(10, Util.GetString(RequestedID), Tranx, "", ComponentDetail[0].IPDCaseTypeID, 0, "0001-01-01", "");


                for (int i = 0; i < ComponentDetail.Count; i++)
                {
                    sb.Clear();
                    sb.Append(" INSERT INTO diet_patient_Component_Detail(TransactionID,PatientID,ComponentID,ItemID,Rate,ComponentName,RateListID,CentreID,Hospital_ID,CreatedBy,Quantity,Amount,RequestedID,DietTimeID,RequestDate)");
                    sb.Append("   VALUES ( '" + ComponentDetail[i].TransactionID + "','" + ComponentDetail[i].PatientID + "','" + ComponentDetail[i].ComponentID + "' ,");
                    sb.Append(" '" + ComponentDetail[i].ItemID + "' , '" + ComponentDetail[i].Rate + "' ,'" + ComponentDetail[i].ComponentName + "' ,'" + ComponentDetail[i].rateListID + "' ,");
                    sb.Append(" '" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "', ");
                    sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + ComponentDetail[i].Quantity + "' ,'" + Util.GetDecimal(ComponentDetail[i].Quantity) * Util.GetDecimal(ComponentDetail[i].Rate) + "','" + RequestedID + "','" + ComponentDetail[i].DietTimeID + "' ,'" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "'");
                    sb.Append("  ) ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());


                }

                Tranx.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";

            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }

        else
        {
            return "2";
        }
    }
    
    [WebMethod]
    public static string getComponent1(string dietTimeID, string subDietID, string menuID, string IPDCaseTypeID,  string RequestDate)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append("SELECT distinct dpd.`RequestedID`,IFNULL(dpd.ID,0)PatComDetail,dmdc.ComponentName,IFNULL(frl.Rate,0)Rate,IFNULL(frl.ID,0)RateListID,dcm.ItemID,dcm.ComponentID,dmdc.Qty,dcm.Type,IFNULL(dcm.Unit,'')Unit,IFNULL(dcm.Calories,'')Calories,IFNULL(dcm.Protein,'')Protein,IFNULL(dcm.Sodium,'')Sodium,IFNULL(dcm.SaturatedFat,'')SaturatedFat, ");
        sb.Append("SELECT distinct '1' as HideSave,'' as PatComDetail,dmdc.ComponentName,IFNULL(frl.Rate,0)Rate,IFNULL(frl.ID,0)RateListID,dcm.ItemID,dcm.ComponentID,dmdc.Qty,dcm.Type,IFNULL(dcm.Unit,'')Unit,IFNULL(dcm.Calories,'')Calories,IFNULL(dcm.Protein,'')Protein,IFNULL(dcm.Sodium,'')Sodium,IFNULL(dcm.SaturatedFat,'')SaturatedFat, ");
        sb.Append(" IFNULL(dcm.T_Fat,'')T_Fat,IFNULL(Calcium,'')Calcium,IFNULL(Iron,'')Iron,IFNULL(zinc,'')zinc,'' TransactionID,'" + IPDCaseTypeID + "' IPDCaseTypeID ,'' Room_ID,'' IsFreeze ,'' PatientID, ");
        sb.Append(" dmdc.DietTimeID dietTimeID,dmdc.SubDietID,dmdc.DietMenuID,dmdc.DietID FROM diet_map_diet_component dmdc ");
        sb.Append(" INNER JOIN diet_component_master dcm ON dcm.ComponentID=dmdc.ComponentID ");
        sb.Append(" LEFT JOIN f_ratelist_ipd frl ON frl.ItemID=dcm.ItemID ");
        if (IPDCaseTypeID != "")
        {
            sb.Append(" AND  IPDcaseTypeID='" + IPDCaseTypeID + "'  ");
        }
        sb.Append(" AND IsCurrent=1 ");
        sb.Append(" LEFT JOIN diet_patient_Component_Detail dpd ON dpd.ComponentID=dcm.ComponentID ");
        
        sb.Append(" AND dpd.IsActive=1 AND dpd.dietTimeID='" + dietTimeID + "'  ");
        if (RequestDate != "")
        {
            sb.Append(" AND DATE(dpd.CreatedDate)='" + Util.GetDateTime(RequestDate).ToString("yyyy-MM-dd") + "' ");
        }
        sb.Append(" WHERE dmdc.DietMenuID='" + menuID + "' AND dmdc.SubDietID='" + subDietID + "' AND dmdc.DietTimeID='" + dietTimeID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    public class dietComponent
        {
        public string TransactionID { get; set; }
        public string IPDCaseTypeID { get; set; }
        public string ItemID { get; set; }
        public string RoomID { get; set; }
        public string SubDietID { get; set; }
        public string DietMenuID { get; set; }
        public string DietTimeID { get; set; }
        public string DietID { get; set; }
        public string RequestDate { get; set; }
        public string IsFreeze { get; set; }
        public string ComponentID { get; set; }
        public string PatientID { get; set; }
        public decimal Rate { get; set; }
        public string rateListID { get; set; }
        public string ComponentName { get; set; }
        public decimal Quantity { get; set; }
        public int patientRequestedID { get; set; }
        public string Transaction_ID { get; set; }
        public string PatientType { get; set; } 
        public string PanelID { get; set; }
        }
    [WebMethod(EnableSession=true)]
    public static string saveComponent(List<List<dietComponent>> ComponentDetaillist)
        {
            int lenlist = ComponentDetaillist.Count;
            if (lenlist > 0)
            {

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                for (int j = 0; j < lenlist; j++)
                {
                    List<dietComponent> ComponentDetail = ComponentDetaillist[j];
                    int len = ComponentDetail.Count;
                    if (len > 0)
                    {
                        
                            if (ComponentDetail[0].patientRequestedID != 0)
                            {
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE pdr.*,pdc.* FROM diet_patient_diet_request pdr INNER JOIN diet_patient_Component_Detail pdc ON pdr.ID=pdc.RequestedID WHERE pdr.ID='" + ComponentDetail[0].patientRequestedID + "' ");
                            }
                            //  MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM diet_patient_diet_request WHERE TransactionID='" + ComponentDetail[0].TransactionID + "' AND DATE(RequestDate)='" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "' AND DietTimeID='" + ComponentDetail[0].DietTimeID + "'");
                            //  MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE  diet_patient_Component_Detail SET IsActive=1 WHERE TransactionID='" + ComponentDetail[0].TransactionID + "' AND DATE(RequestDate)='" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "' AND DietTimeID='" + ComponentDetail[0].DietTimeID + "'");


                            StringBuilder sb = new StringBuilder();
                            sb.Append("INSERT INTO diet_patient_diet_request(TransactionID,SubDietID,DietMenuID,DietTimeID,Remarks,EnterBy,DietID,IPDCaseTypeID,RoomID,RequestDate)");
                            sb.Append(" VALUES ('" + ComponentDetail[0].TransactionID + "','" + ComponentDetail[0].SubDietID + "','" + ComponentDetail[0].DietMenuID + "', ");
                            sb.Append(" '" + ComponentDetail[0].DietTimeID + "','','" + HttpContext.Current.Session["ID"] + "','" + ComponentDetail[0].DietID + "','" + ComponentDetail[0].IPDCaseTypeID + "', ");
                            sb.Append(" " + ComponentDetail[0].RoomID + ",'" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "')");
                            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());


                            int RequestedID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT (MAX(ID)+"+j+") FROM diet_patient_diet_request"));

                            Notification_Insert.notificationInsert(10, Util.GetString(RequestedID), Tranx, "", ComponentDetail[0].IPDCaseTypeID, 0, "0001-01-01", "");


                            for (int i = 0; i < ComponentDetail.Count; i++)
                            {
                                sb.Clear();
                                sb.Append(" INSERT INTO diet_patient_Component_Detail(TransactionID,PatientID,ComponentID,ItemID,Rate,ComponentName,RateListID,CentreID,Hospital_ID,CreatedBy,Quantity,Amount,RequestedID,DietTimeID,RequestDate)");
                                sb.Append("   VALUES ( '" + ComponentDetail[i].TransactionID + "','" + ComponentDetail[i].PatientID + "','" + ComponentDetail[i].ComponentID + "' ,");
                                sb.Append(" '" + ComponentDetail[i].ItemID + "' , '" + ComponentDetail[i].Rate + "' ,'" + ComponentDetail[i].ComponentName + "' ,'" + ComponentDetail[i].rateListID + "' ,");
                                sb.Append(" '" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "', ");
                                sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + ComponentDetail[i].Quantity + "' ,'" + Util.GetDecimal(ComponentDetail[i].Quantity) * Util.GetDecimal(ComponentDetail[i].Rate) + "','" + RequestedID + "','" + ComponentDetail[i].DietTimeID + "' ,'" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "'");
                                sb.Append("  ) ");
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());


                            }

                        
                    }

                    else
                    {
                        return "2";
                    }

                }

                Tranx.Commit();
                return "1";
                }
                catch (Exception ex)
                {
                    Tranx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0";

                }
                finally
                {
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }
            else
            {
                return "2";
            }
        }
    [WebMethod(EnableSession = true)]
    public static string receivedDiet(string RequestID)
        {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
            {

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_patient_diet_request   SET IsReceived = 1, receivedBy='" + HttpContext.Current.Session["ID"].ToString() + "',receiveDate=NOW(),receiveIPAddress='"+HttpContext.Current.Request.UserHostAddress+"' WHERE ID = '" + RequestID + "'");

           // Notification_Insert.notificationInsert(12, Util.GetString(RequestID), Tranx, "", "", 0, "", "");
            All_LoadData.updateNotification(Util.GetString(RequestID), "", "", 11, Tranx, "Diet");
            Tranx.Commit();
            return "1";
            }
        catch (Exception ex)
            {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";

            }
        finally
            {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            }
        }

    [WebMethod(EnableSession = true)]
    public static string receivedAttendentDiet(string RequestID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE diet_attendent_diet_request SET IsReceived = 1, receivedBy='" + HttpContext.Current.Session["ID"].ToString() + "',receiveDate=NOW(),receiveIPAddress='" + HttpContext.Current.Request.UserHostAddress + "' WHERE ID = '" + RequestID + "'");

            // Notification_Insert.notificationInsert(12, Util.GetString(RequestID), Tranx, "", "", 0, "", "");
            // All_LoadData.updateNotification(Util.GetString(RequestID), "", "", 11, Tranx, "Diet");
            Tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    [WebMethod(EnableSession = true)]
    public static string saveComponentAttendent(List<dietComponent> ComponentDetail, string requestID, string Remarks)
    {
        int len = ComponentDetail.Count;
        if (len > 0)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string requestComponentIDs = string.Empty;
                int RequestedID;

                StringBuilder sb = new StringBuilder();
                if (requestID == "0")
                {
                    sb.Append("INSERT INTO diet_attendent_diet_request(TransactionID,SubDietID,DietMenuID,DietTimeID,Remarks,EnterBy,DietID,IPDCaseTypeID,RoomID,RequestDate)");
                    sb.Append(" VALUES ('" + ComponentDetail[0].Transaction_ID + "','" + ComponentDetail[0].SubDietID + "','" + ComponentDetail[0].DietMenuID + "', ");
                    sb.Append(" '" + ComponentDetail[0].DietTimeID + "','" + Remarks.Replace("'", "").Trim() + "','" + HttpContext.Current.Session["ID"] + "','" + ComponentDetail[0].DietID + "','" + ComponentDetail[0].IPDCaseTypeID + "', ");
                    sb.Append(" '" + ComponentDetail[0].RoomID + "','" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "')");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

                    RequestedID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT MAX(ID) FROM diet_attendent_diet_request"));

                    // Notification_Insert.notificationInsert(10, Util.GetString(RequestedID), Tranx, "", ComponentDetail[0].IPDCaseTypeID, 0, "0001-01-01", "");
                }
                else
                {
                    RequestedID = Util.GetInt(requestID);
                }

                string id = string.Empty;

                for (int i = 0; i < ComponentDetail.Count; i++)
                {
                    sb.Clear();
                    sb.Append(" INSERT INTO diet_attendent_Component_Detail(Transaction_ID,Patient_ID,ComponentID,ItemID,Rate,ComponentName,RateListID,CentreID,Hospital_ID,CreatedBy,Quantity,Amount,RequestedID,DietTimeID,RequestDate)");
                    sb.Append("   VALUES ( '" + ComponentDetail[i].Transaction_ID + "','" + ComponentDetail[i].PatientID + "','" + ComponentDetail[i].ComponentID + "' ,");
                    sb.Append(" '" + ComponentDetail[i].ItemID + "' , '" + ComponentDetail[i].Rate + "' ,'" + ComponentDetail[i].ComponentName + "' ,'" + ComponentDetail[i].rateListID + "' ,");
                    sb.Append(" '" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "','" + HttpContext.Current.Session["HOSPID"].ToString() + "', ");
                    sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + ComponentDetail[i].Quantity + "' ,'" + Util.GetDecimal(ComponentDetail[i].Quantity) * Util.GetDecimal(ComponentDetail[i].Rate) + "','" + RequestedID + "','" + ComponentDetail[i].DietTimeID + "' ,'" + Util.GetDateTime(ComponentDetail[0].RequestDate).ToString("yyyy-MM-dd") + "'");
                    sb.Append("  ) ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

                    id = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT MAX(ID) FROM diet_attendent_Component_Detail"));

                    if (requestComponentIDs == string.Empty)
                        requestComponentIDs = "'" + id + "'";
                    else
                        requestComponentIDs += ",'" + id + "'";
                }

                if (id == string.Empty)
                {
                    Tranx.Rollback();
                    return "0";
                }

                // Modify on 29-06-2017 - For GST
                //string query = " SELECT ComponentID,ComponentName ItemDisplayName,ItemID,Rate,Quantity,RateListID,NOW() Date,'" + Resources.Resource.DietSubcategoryID + "' SubCategoryID,'7' TnxTypeID, " +
                //             " '' ItemCode,'" + Resources.Resource.DoctorID_Self + "' Doctor_ID,'0' DocCharges,'10'ConfigRelationID   FROM diet_attendent_component_detail WHERE ID IN (" + requestComponentIDs + ") ";
                string query = " SELECT dpcd.ComponentID,dpcd.ComponentName ItemDisplayName,dpcd.ItemID,dpcd.Rate,dpcd.Quantity,dpcd.RateListID,NOW() Date,'" + Resources.Resource.DietSubcategoryID + "' SubCategoryID,'7' TnxTypeID, " +
                               " '' ItemCode,'" + Resources.Resource.DoctorID_Self + "' DoctorID,'0' DocCharges,'10'ConfigRelationID,im.HSNCode,im.IGSTPercent,im.CGSTPercent,im.SGSTPercent,im.GSTType FROM diet_attendent_component_detail dpcd INNER JOIN f_itemmaster im ON dpcd.ItemID=im.ItemID WHERE dpcd.ID IN (" + requestComponentIDs + ") ";
                DataTable dtItem = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, query).Tables[0];

                dtItem = IPDBilling.UpdateLedgerForIPDBilling(dtItem, Util.GetString(ComponentDetail[0].PatientID), "IPD-Billing", Util.GetInt(ComponentDetail[0].PanelID), HttpContext.Current.Session["ID"].ToString(), Util.GetString(ComponentDetail[0].Transaction_ID), Util.GetString(HttpContext.Current.Session["HOSPID"].ToString()), "Yes", "1", Tranx, Util.GetString(ComponentDetail[0].IPDCaseTypeID), Util.GetString(ComponentDetail[0].PatientType), con, ComponentDetail[0].RoomID);

                if (dtItem == null)
                {
                    Tranx.Rollback();
                    return "0";
                }

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE  diet_attendent_Component_Detail SET LedgerTransactionNo='" + Util.GetString(dtItem.Rows[0]["LedgerTransactionNo"]) + "' WHERE ID IN (" + requestComponentIDs + ") ");

                Tranx.Commit();
                return RequestedID.ToString() + "#" + Remarks;
            }
            catch (Exception ex)
            {
                Tranx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "2";
        }
    }


}