using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;


public partial class Design_OT_PRE_DepartmentOfSurgery : System.Web.UI.Page
{
    DataTable dt;
    public static string UserNameforDisplay;
    public string LedgerTransactionNo;
    string Query = "";
	
    [WebMethod]
    public static string bindSavedStaff(int OTBookingID)
    {
        DataTable dt = StockReports.GetDataTable("  SELECT o.`StaffTypeID`,o.`StaffID`,o.`StaffName`,TIME_FORMAT(o.`StartTime`,'%I:%i %p') as StartTime,TIME_FORMAT(o.`EndTme`,'%I:%i %p') as EndTme,otm.`StaffTypeName` FROM ot_patienttat o INNER JOIN `ot_staff_type_master` otm ON otm.`ID`=o.`StaffTypeID` WHERE o.`OTBookingID`=" + OTBookingID + " AND o.`IsActive`=1 AND o.`TATTypeID`=3  order by FIELD(otm.StaffTypeName,'SURGEON','Assistant Surgeon','Nurse')");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtSurgeryDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtstartTime.Text = "00:00 AM";
            txtFinishTime.Text = "11:59 PM";
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();
            ViewState["LedgerTransactionNo"] = Request.QueryString["OTBookingID"].ToString();
            UserNameforDisplay = Session["LoginName"].ToString();
            //BindddlSurgeon1();
            //BindddlSurgeon2();
            //BindAnesthetist();
            //BindAnesthetistTech();
            //BindAstSurgeon1();
            //BindAstSurgeon2();
            //BindScrubNurse();
            //BindcalNurse();
            BindddlProcedure();
            BindSurgery();        
            BindddlSurgeonassign();
            BindddlPrimaryAndSecondaryProcedure();
            BindData();
            BindEntryDetails();
        }
        txtSurgeryDate.Attributes.Add("readOnly", "readOnly");
    }

    protected void BindEntryDetails()
    {
        try
        {
            DataTable dtdetail = StockReports.GetDataTable(" SELECT cod.ID,CONCAT(em.Title,' ',em.Name)EntryBy,CONCAT(DATE_FORMAT(cod.CreatedDate,'%d-%b-%Y'),'  ',TIME_FORMAT(cod.CreatedDate,'%h:%i %p'))EntryTime FROM cpoe_OTNotes_DeptofSurgery cod inner JOIN employee_master em ON em.EmployeeID=cod.CreatedBy WHERE cod.PatientID='" + ViewState["PID"] + " ' AND cod.TransactionID='" + ViewState["TID"] + "' ORDER BY cod.id DESC  ");
            if (dtdetail.Rows.Count > 0)
            {
                grdPhysical.DataSource = dtdetail;
                grdPhysical.DataBind();
            }
            else
            {
                grdPhysical.DataSource = null;
                grdPhysical.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);           
        }
    }

    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {           
            if (e.CommandName == "imbPrint")
            {
                string id = e.CommandArgument.ToString();

                DataSet ds = new DataSet();
                DataTable dt = StockReports.GetDataTable(@"
                SELECT  PatientID,TransactionID,LedgerTransactionNo,SurgeonName1,SurgeonName2,AsstSurgeon1,AsstSurgeon2,Anesthetist,AsstAnesthetist,
                ScrubNurse,CirculNurse,SurgeryDate,Urgency,SurStartTime,SurFinishTime,PreOperatveDignose,Operation,Incisions1,Incisions2,
                Findings,Drains,Closure,Sample,Complication,BloodLoss,PostOprDignosis,PostOpInstruction,CreatedBy,CreatedDate,Ports,
                Procedures,AnesthesiaType,SurgeryID,SurgeryName,PrimaryProcedureVal,SecondaryProcedureVal,PrimaryProcedureText,SecondaryProcedureText,Department,
                WoundClassification,NatureOfSurgary,IsOtherSurgery,OtherSurgery FROM cpoe_OTNotes_DeptofSurgery WHERE ID = '" + id + "'  ");
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "Departmentofsurgery";
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[1].TableName = "logo";

                // ds.WriteXmlSchema(@"E:\Departmentofsurgery.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "Departmentofsurgery";
                Session["ds"] = ds;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private void BindData()
    {
        Query = " SELECT (Select concat(title,' ',name) from Employee_master em where em.EmployeeID=iu.UpdatedBy)UpdatedBy1,DATE_FORMAT(UpdatedDate, '%d %b %Y %h:%i %p') as UpdatedDate1,(Select concat(title,' ',name) from Employee_master em where em.EmployeeID=iu.CreatedBy)CreatedBy1,DATE_FORMAT(CreatedDate, '%d %b %Y %h:%i %p') as CreatedDate1,SurgeonName1,SurgeonName2,AsstSurgeon1,AsstSurgeon2,Anesthetist,AsstAnesthetist,ScrubNurse,CirculNurse, " +
              " SurgeryDate,Urgency,DATE_FORMAT(SurStartTime,'%l:%i %p')SurStartTime,DATE_FORMAT(SurFinishTime,'%l:%i %p')SurFinishTime,PreOperatveDignose,Operation,Incisions1,Incisions2,Findings,Drains,Closure,Sample,Complication, " +
              " BloodLoss,PostOprDignosis,PostOpInstruction,Ports,Procedures,AnesthesiaType,SurgeryID,SurgeryName,PrimaryProcedureVal,SecondaryProcedureVal,PrimaryProcedureText,SecondaryProcedureText,Department,WoundClassification,NatureOfSurgary,IsOtherSurgery,OtherSurgery FROM cpoe_OTNotes_DeptofSurgery iu WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND LedgerTransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "' AND iu.IsActive=1 ";

        dt = StockReports.GetDataTable(Query);

        if (dt.Rows.Count > 0)
        {
           /* if (dt.Rows[0]["UpdatedBy1"] != DBNull.Value)
            {
                lblLastUpdatedBy.Text = dt.Rows[0]["UpdatedBy1"].ToString();
                lblLastUpdatedDate.Text = dt.Rows[0]["UpdatedDate1"].ToString();
            }
            else
            {
                lblLastUpdatedBy.Text = dt.Rows[0]["CreatedBy1"].ToString();
                lblLastUpdatedDate.Text = dt.Rows[0]["CreatedDate1"].ToString();
            } */

            // ddlSurgeon1.SelectedIndex = ddlSurgeon1.Items.IndexOf(ddlSurgeon1.Items.FindByText(dt.Rows[0]["SurgeonName1"].ToString()));
            // ddlSurgeon2.SelectedIndex = ddlSurgeon2.Items.IndexOf(ddlSurgeon2.Items.FindByText(dt.Rows[0]["SurgeonName2"].ToString()));
            // ddlAstSurgeon1.SelectedIndex = ddlAstSurgeon1.Items.IndexOf(ddlAstSurgeon1.Items.FindByText(dt.Rows[0]["AsstSurgeon1"].ToString()));
            // ddlAstSurgeon2.SelectedIndex = ddlAstSurgeon2.Items.IndexOf(ddlAstSurgeon2.Items.FindByText(dt.Rows[0]["AsstSurgeon2"].ToString()));
            // ddlAnesthetsit.SelectedIndex = ddlAnesthetsit.Items.IndexOf(ddlAnesthetsit.Items.FindByText(dt.Rows[0]["Anesthetist"].ToString()));
            // ddlAnesthetsittech.SelectedIndex = ddlAnesthetsittech.Items.IndexOf(ddlAnesthetsittech.Items.FindByText(dt.Rows[0]["AsstAnesthetist"].ToString()));
            // ddlScrubNurse.SelectedIndex = ddlScrubNurse.Items.IndexOf(ddlScrubNurse.Items.FindByText(dt.Rows[0]["ScrubNurse"].ToString()));
            // ddlcalNurse.SelectedIndex = ddlcalNurse.Items.IndexOf(ddlcalNurse.Items.FindByText(dt.Rows[0]["CirculNurse"].ToString()));
            // ddlSurgery.SelectedIndex = ddlSurgery.Items.IndexOf(ddlSurgery.Items.FindByValue(dt.Rows[0]["SurgeryID"].ToString()));
            // txtSurgeryDate.Text = Util.GetDateTime(dt.Rows[0]["SurgeryDate"].ToString()).ToString("dd-MMM-yyyy");

            txtUrgency.Text = dt.Rows[0]["Urgency"].ToString();
            // txtstartTime.Text = dt.Rows[0]["SurStartTime"].ToString();
            // txtFinishTime.Text = dt.Rows[0]["SurFinishTime"].ToString();
            txtDiagnosis.Text = dt.Rows[0]["PreOperatveDignose"].ToString();
            txtOperation.Text = dt.Rows[0]["Operation"].ToString();
            txtIncisions1.Text = dt.Rows[0]["Incisions1"].ToString();
            txtIncisions2.Text = dt.Rows[0]["Incisions2"].ToString();
            txtfindings.Text = dt.Rows[0]["Findings"].ToString();
            txtDrains.Text = dt.Rows[0]["Drains"].ToString();
            txtClousre.Text = dt.Rows[0]["Closure"].ToString();
            txtsample.Text = dt.Rows[0]["Sample"].ToString();
            txtcomplications.Text = dt.Rows[0]["Complication"].ToString();
            txtbloodloss.Text = dt.Rows[0]["BloodLoss"].ToString();
            txtPostODiagnosi.Text = dt.Rows[0]["PostOprDignosis"].ToString();
            txtPostOInstructions.Text = dt.Rows[0]["PostOpInstruction"].ToString();
            
            ddlSurgeonassign.SelectedIndex = ddlSurgeonassign.Items.IndexOf(ddlSurgeonassign.Items.FindByText(dt.Rows[0]["SurgeonName1"].ToString()));
            ddlPrimaryProcedure.SelectedValue = dt.Rows[0]["PrimaryProcedureVal"].ToString();
            ddlSecondaryProcedure.SelectedValue = dt.Rows[0]["SecondaryProcedureVal"].ToString();

            ddlDepartment.SelectedValue = dt.Rows[0]["Department"].ToString();
            ddlWoundClassification.SelectedValue = dt.Rows[0]["WoundClassification"].ToString();
            ddlNatureOfSurgery.SelectedValue = dt.Rows[0]["NatureOfSurgary"].ToString();

            // Devendra Singh 2016.03.05

            txtPorts.Text = dt.Rows[0]["Ports"].ToString();
            txtProcedures.Text = (dt.Rows[0]["Procedures"].ToString()).Replace("#", "'");
            ddlAnesthesiatype.SelectedIndex = ddlAnesthesiatype.Items.IndexOf(ddlAnesthesiatype.Items.FindByText(dt.Rows[0]["AnesthesiaType"].ToString()));
            chkIsOtherSurgery.Checked = false;

            if (Util.GetInt(dt.Rows[0]["IsOtherSurgery"].ToString()) == 1)
            { 
                chkIsOtherSurgery.Checked = true;
            }

            txtOtherSurgery.Text = dt.Rows[0]["OtherSurgery"].ToString();


            // txtAnesthesia.Text = dt.Rows[0]["AnesthesiaType"].ToString();
            btnSave.Text = "Update";
           // btnprint.Visible = true;
        }
        else
        {
            StringBuilder sb = new StringBuilder();
            DataTable dtnew = StockReports.GetDataTable("select surgery_schedule_ID,(select DoctorID from doctor_master where DoctorID=ot.DoctorID) DoctorName,(select Name from f_surgery_master where Surgery_ID=ot.Surgery_ID) as Surgery,OT,Date(ot.Start_DateTime) as Start_DateTime,Date_format(ot.Start_DateTime,'%l:%i %p') as Start_Time,Date_FORMAT(ot.End_Datetime,'%d-%m-%Y %H.%i.%s') as End_Datetime,Date_FORMAT(ot.End_Datetime,'%l:%i %p') as End_time,Surgery_ID,(select DoctorID from doctor_master where DoctorID=ot.Ass_Doc1) as Ass_Doc1,(select DoctorID from doctor_master where DoctorID=ot.Ass_Doc2)Ass_Doc2, " +
                " Ass_Doc3,(select DoctorID from doctor_master where DoctorID=ot.Anaesthetist1) as Anaesthetist1,Anaesthetist2,CoAnaesthesia,(select Name from ot_anaesthesiatechnicians Where ID=ot.technician) as technician,(select Name from ot_ottechnician where ID=ScNurse)as ScNurse,(select Name from ot_ottechnician where ID=Nurse1)as Nurse1,(select Name from ot_ottechnician where ID=Nurse2)as Nurse2,(select Name from ot_ottechnician where ID=FloorSuprevisior)as FloorSuprevisior, " +
            " CirculatingNurse,PadiatriciansRecort,Weight,Remarks,ApgarScore,IsCancel,CancelUserID, " +
            " CancelReason,CancelDatetime,EntDate,UserID from ot_surgery_schedule ot  where IsCancel=0 and TransactionID='" + ViewState["TID"].ToString() + "' and LedgerTransactionNo='" + ViewState["LedgerTransactionNo"] + "'");
            if (dtnew.Rows.Count > 0)
            {
                //ddlSurgeon1.SelectedIndex = ddlSurgeon1.Items.IndexOf(ddlSurgeon1.Items.FindByValue(dtnew.Rows[0]["DoctorName"].ToString()));
                // ddlSurgeon2.SelectedIndex = ddlSurgeon2.Items.IndexOf(ddlSurgeon2.Items.FindByText(dt.Rows[0]["Ass_Doc1"].ToString()));
                //ddlAstSurgeon1.SelectedIndex = ddlAstSurgeon1.Items.IndexOf(ddlAstSurgeon1.Items.FindByValue(dtnew.Rows[0]["Ass_Doc1"].ToString()));
                //ddlAstSurgeon2.SelectedIndex = ddlAstSurgeon2.Items.IndexOf(ddlAstSurgeon2.Items.FindByValue(dtnew.Rows[0]["Ass_Doc2"].ToString()));
                //ddlAnesthetsit.SelectedIndex = ddlAnesthetsit.Items.IndexOf(ddlAnesthetsit.Items.FindByValue(dtnew.Rows[0]["Anaesthetist1"].ToString()));
                //ddlAnesthetsittech.SelectedIndex = ddlAnesthetsittech.Items.IndexOf(ddlAnesthetsittech.Items.FindByValue(dtnew.Rows[0]["Anaesthetist2"].ToString()));
                //ddlScrubNurse.SelectedIndex = ddlScrubNurse.Items.IndexOf(ddlScrubNurse.Items.FindByText(dtnew.Rows[0]["ScNurse"].ToString()));
                //ddlcalNurse.SelectedIndex = ddlcalNurse.Items.IndexOf(ddlcalNurse.Items.FindByText(dtnew.Rows[0]["Nurse2"].ToString()));
                //txtSurgeryDate.Text = Util.GetDateTime(dtnew.Rows[0]["Start_DateTime"].ToString()).ToString("dd-MMM-yyyy");
                //ddlSurgery.SelectedIndex = ddlSurgery.Items.IndexOf(ddlSurgery.Items.FindByText(dtnew.Rows[0]["Surgery"].ToString()));
                //txtstartTime.Text = dtnew.Rows[0]["Start_Time"].ToString();
                //txtFinishTime.Text = dtnew.Rows[0]["End_time"].ToString();
            }
        }
    }

    private void BindcalNurse()
    {
        dt = StockReports.GetDataTable("SELECT id as EmployeeID,NAME as UserName FROM OT_ottechnician");
        ddlcalNurse.DataSource = dt;
        ddlcalNurse.DataTextField = "UserName";
        ddlcalNurse.DataValueField = "EmployeeID";
        ddlcalNurse.DataBind();
        ddlcalNurse.Items.Insert(0, " ");
        ddlcalNurse.SelectedIndex = 0;
    }

    private void BindScrubNurse()
    {
        dt = StockReports.GetDataTable("SELECT id as EmployeeID,NAME as UserName FROM OT_ottechnician");
        ddlScrubNurse.DataSource = dt;
        ddlScrubNurse.DataTextField = "UserName";
        ddlScrubNurse.DataValueField = "EmployeeID";
        ddlScrubNurse.DataBind();
        ddlScrubNurse.Items.Insert(0, " ");
        ddlScrubNurse.SelectedIndex = 0;
    }

    private void BindAstSurgeon2()
    {
        DataTable dt = All_LoadData.bindDoctor();
        ddlAstSurgeon2.DataSource = dt;
        ddlAstSurgeon2.DataTextField = "Name";
        ddlAstSurgeon2.DataValueField = "DoctorID";
        ddlAstSurgeon2.DataBind();
        ddlAstSurgeon2.Items.Insert(0, " ");
    }

    private void BindAstSurgeon1()
    {
        DataTable dt = All_LoadData.bindDoctor();
        ddlAstSurgeon1.DataSource = dt;
        ddlAstSurgeon1.DataTextField = "Name";
        ddlAstSurgeon1.DataValueField = "DoctorID";
        ddlAstSurgeon1.DataBind();
        ddlAstSurgeon1.Items.Insert(0, " ");
        // ddlAstSurgeon1.SelectedIndex = 0;
    }

    private void BindAnesthetistTech()
    {
        dt = StockReports.GetDataTable(" select ID as DoctorID,Name from ot_anaesthesiatechnicians ");
        ddlAnesthetsittech.DataSource = dt;
        ddlAnesthetsittech.DataTextField = "Name";
        ddlAnesthetsittech.DataValueField = "DoctorID";
        ddlAnesthetsittech.DataBind();
        ddlAnesthetsittech.Items.Insert(0, " ");
        //ddlAnesthetsittech.SelectedIndex = 0;
    }

    private void BindAnesthetist()
    {
        DataTable dt = All_LoadData.dtAnesthesiadoctor();
        ddlAnesthetsit.DataSource = dt;
        ddlAnesthetsit.DataTextField = "Name";
        ddlAnesthetsit.DataValueField = "DoctorID";
        ddlAnesthetsit.DataBind();
        ddlAnesthetsit.Items.Insert(0, " ");
        ddlAnesthetsit.SelectedIndex = 0;
    }
    private void BindddlSurgeon1()
    {
        DataTable dt = All_LoadData.bindDoctor();
        ddlSurgeon1.DataSource = dt;
        ddlSurgeon1.DataTextField = "Name";
        ddlSurgeon1.DataValueField = "DoctorID";
        ddlSurgeon1.DataBind();
        ddlSurgeon1.Items.Insert(0, " ");
        ddlSurgeon1.SelectedIndex = 0;
    }
    private void BindddlSurgeon2()
    {
        DataTable dt = All_LoadData.bindDoctor();
        ddlSurgeon2.DataSource = dt;
        ddlSurgeon2.DataTextField = "Name";
        ddlSurgeon2.DataValueField = "DoctorID";
        ddlSurgeon2.DataBind();
        ddlSurgeon2.Items.Insert(0, " ");
        ddlSurgeon2.SelectedIndex = 0;
    }
    private void BindddlSurgeonassign()
    {

        DataTable dt = StockReports.GetDataTable(" SELECT o.`StaffID` DoctorID,o.`StaffName` AS NAME  FROM ot_patienttat o  INNER JOIN `ot_staff_type_master` otm ON otm.`ID`=o.`StaffTypeID` WHERE o.`OTBookingID`='" + ViewState["LedgerTransactionNo"] + "' AND o.`IsActive`=1 AND otm.`ID`=1 ");
        ddlSurgeonassign.DataSource = dt;
        ddlSurgeonassign.DataTextField = "Name";
        ddlSurgeonassign.DataValueField = "DoctorID";
        ddlSurgeonassign.DataBind();
        ddlSurgeonassign.Items.Insert(0, "select");
        ddlSurgeonassign.SelectedIndex = 0;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int a = 0;
            txtProcedures.Text = txtProcedures.Text.Replace("'", " ");
            if (txtProcedures.Text == "<br>")
                txtProcedures.Text = txtProcedures.Text.Replace("<br>", "");
            else if (txtProcedures.Text == "<BR>")
                txtProcedures.Text = txtProcedures.Text.Replace("<BR>", "");
            else if (txtProcedures.Text == " <br> ")
                txtProcedures.Text = txtProcedures.Text.Replace(" <br> ", "");
            else if (txtProcedures.Text == " <BR> ")
                txtProcedures.Text = txtProcedures.Text.Replace(" <BR> ", "");
            else if (txtProcedures.Text == "<br /> ")
                txtProcedures.Text = txtProcedures.Text.Replace("<br/> ", "<br>");
            if (txtProcedures.Text.Contains("<br />"))
                txtProcedures.Text = txtProcedures.Text.Replace("<br />", "<br>");
            if (txtProcedures.Text.EndsWith("<BR></P>"))
            {
                int lenght = txtProcedures.Text.Length;
                txtProcedures.Text = txtProcedures.Text.Substring(0, lenght - 8) + "</P>";
            }
            else if (txtProcedures.Text.EndsWith("<BR>"))
            {
                int lenght = txtProcedures.Text.Length;
                txtProcedures.Text = txtProcedures.Text.Substring(0, lenght - 4);
            }

            int IsOtherSurgery = Util.getbooleanInt(chkIsOtherSurgery.Checked);

            if (btnSave.Text == "Update")
            {
                Query = " Update cpoe_OTNotes_DeptofSurgery set IsActive=0 Where IsActive=1 AND TransactionID = '" + ViewState["TID"].ToString() + "' AND LedgerTransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "' ";
                a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            }

            string d = ViewState["PID"].ToString();
            string es = ViewState["TID"].ToString();
            string dw = ViewState["LedgerTransactionNo"].ToString();

            Query = "Insert INTO cpoe_OTNotes_DeptofSurgery " +
                " (PatientID,TransactionID,LedgerTransactionNo,SurgeonName1,SurgeonName2,AsstSurgeon1,AsstSurgeon2,Anesthetist,AsstAnesthetist,ScrubNurse,CirculNurse, " +
                 " SurgeryDate,Urgency,SurStartTime,SurFinishTime,PreOperatveDignose,Operation,Incisions1,Incisions2,Findings,Drains,Closure,Sample,Complication," +
                 " BloodLoss,PostOprDignosis,PostOpInstruction,CreatedBy,CreatedDate,Ports,Procedures,AnesthesiaType,SurgeryID,SurgeryName,PrimaryProcedureVal,SecondaryProcedureVal,PrimaryProcedureText,SecondaryProcedureText,Department,WoundClassification,NatureOfSurgary,IsOtherSurgery,OtherSurgery ) " +
                 "VALUES ( '" + ViewState["PID"].ToString() + "','" + ViewState["TID"].ToString() + "','" + ViewState["LedgerTransactionNo"].ToString() + "','" + ddlSurgeonassign.SelectedItem.Text.ToString() + "','','',''," +
                            " '','','','','0001-01-01','" + txtUrgency.Text.Trim() + "','00:00:00'," +
                            " '00:00:00','" + txtDiagnosis.Text.Replace("'", "").Trim() + "','" + txtOperation.Text.Replace("'", "").Trim() + "','" + txtIncisions1.Text.Replace("'", "").Trim() + "','" + txtIncisions2.Text.Replace("'", "").Trim() + "','" + txtfindings.Text.Replace("'", "").Trim() + "','" + txtDrains.Text.Replace("'", "").Trim() + "'," +
                            " '" + txtClousre.Text.Replace("'", "").Trim() + "','" + txtsample.Text.Replace("'", "").Trim() + "','" + txtcomplications.Text.Replace("'", "").Trim() + "','" + txtbloodloss.Text.Replace("'", "").Trim() + "','" + txtPostODiagnosi.Text.Replace("'", "").Trim() + "','" + txtPostOInstructions.Text.Replace("'", "").Trim() + "', " +
                            " '" + Session["ID"].ToString() + "',NOW(),'" + txtPorts.Text.Replace("'", "").Trim() + "','" + txtProcedures.Text + "','" + ddlAnesthesiatype.SelectedItem.Text.Trim() + "','" + ddlSurgery.SelectedItem.Value + "','" + ddlSurgery.SelectedItem.Text + "', "+
                            " '" + ddlPrimaryProcedure.SelectedValue.ToString() + "','" + ddlSecondaryProcedure.SelectedValue.ToString() + "' ,'" + ddlPrimaryProcedure.SelectedItem.Text.ToString() + "' ,'" + ddlSecondaryProcedure.SelectedItem.Text.ToString() + "','" + ddlDepartment.SelectedValue.ToString() + "' ,'" + ddlWoundClassification.SelectedValue.ToString() + "' ,'" + ddlNatureOfSurgery.SelectedValue.ToString() + "'," + IsOtherSurgery + ",'" + txtOtherSurgery.Text.ToString() + "' )";

            a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
            if (a == 0)
            {
                Tranx.Rollback();
                lblMsg.Text = "Error occurred, Please contact administrator";
                return;
            }
            else if (btnSave.Text == "Update")
            {
                lblMsg.Text = "Record Updated Successfully";
            }
            else
            {
                lblMsg.Text = "Record Saved Successfully";
            }
            BindData();
            btnSave.Text = "Update";
            Tranx.Commit();

            /* else
             {
                 Query = " UPDATE cpoe_OTNotes_DeptofSurgery SET " +
                                 " Urgency='" + txtUrgency.Text.Replace("'", "").Trim() + "',PreOperatveDignose='" + txtDiagnosis.Text.Replace("'", "").Trim() + "', " +
                                 " Operation='" + txtOperation.Text.Replace("'", "").Trim() + "',Incisions1='" + txtIncisions1.Text.Replace("'", "").Trim() + "',Incisions2='" + txtIncisions1.Text.Replace("'", "").Trim() + "',Findings='" + txtfindings.Text.Replace("'", "").Trim() + "',Drains='" + txtDrains.Text.Replace("'", "").Trim() + "',Closure='" + txtClousre.Text.Replace("'", "").Trim() + "',Sample='" + txtsample.Text.Replace("'", "").Trim() + "',Complication='" + txtcomplications.Text.Replace("'", "").Trim() + "'," +
                                 " BloodLoss='" + txtbloodloss.Text.Replace("'", "").Trim() + "',PostOprDignosis='" + txtPostODiagnosi.Text.Replace("'", "").Trim() + "',PostOpInstruction='" + txtPostOInstructions.Text.Replace("'", "").Replace("'", "") + "',UpdatedBy='" + Session["ID"].ToString() + "',UpdatedDate=Now(),Ports='" + txtPorts.Text.Trim().Replace("'", "") + "',Procedures='" + (txtProcedures.Text.Trim()).Replace("'", "#") + "',AnesthesiaType='" + ddlAnesthesiatype.SelectedItem.Text.Trim() + "', " +
                                 " SurgeryID='" + ddlSurgery.SelectedItem.Value + "',SurgeryName='" + ddlSurgery.SelectedItem.Text + "',PrimaryProcedureVal='" + ddlPrimaryProcedure.SelectedValue.ToString() + "',SecondaryProcedureVal='" + ddlSecondaryProcedure.SelectedValue.ToString() + "',PrimaryProcedureText='" + ddlPrimaryProcedure.SelectedItem.Text.ToString() + "',SecondaryProcedureText='" + ddlSecondaryProcedure.SelectedItem.Text.ToString() + "',Department='" + ddlDepartment.SelectedValue.ToString() + "',WoundClassification='" + ddlWoundClassification.SelectedValue.ToString() + "',NatureOfSurgary='" + ddlNatureOfSurgery.SelectedValue.ToString() + "',IsOtherSurgery=" + IsOtherSurgery + ",OtherSurgery='" + txtOtherSurgery.Text.ToString() + "'  Where TransactionID ='" + ViewState["TID"].ToString() + "' AND LedgerTransactionNo='" + ViewState["LedgerTransactionNo"].ToString() + "' ";

                 a = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Query);
                 if (a == 0)
                 {
                     Tranx.Rollback();
                     lblMsg.Text = "Error occurred, Please contact administrator";
                     return;
                 }
                 lblMsg.Text = "Record Updated Successfully";
             } 
               Tranx.Commit();
               BindData(); */
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            lblMsg.Text = "Error occurred, Please contact administrator";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private void BindddlProcedure()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select Temp_Name,Template_Value from ot_procedure_template order by Temp_Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlProcedure.DataSource = dt;
            ddlProcedure.DataTextField = "Temp_Name";
            ddlProcedure.DataValueField = "Template_Value";
            ddlProcedure.DataBind();
            ddlProcedure.Items.Insert(0, "select");
            ddlProcedure.SelectedIndex = 0;

        }

    }

    private void BindddlPrimaryAndSecondaryProcedure()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT('CPT: ',im.ItemCode,' ',im.TypeName)Name,im.itemid Id FROM f_itemmaster im INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID =im.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid AND cf.configID=25 AND cf.categoryid=46 WHERE sm.active=1 AND im.IsActive=1 ORDER BY im.TypeName ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        //DataTable dt = StockReports.GetDataTable("select Surgery_ID Id, ltrim(Name) Name from f_surgery_master Where IsActive = 1 order by ltrim(Name)");
         
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlPrimaryProcedure.DataSource = dt;
            ddlPrimaryProcedure.DataTextField = "Name";
            ddlPrimaryProcedure.DataValueField = "Id";
            ddlPrimaryProcedure.DataBind();
            ddlPrimaryProcedure.Items.Insert(0, "select");
            ddlPrimaryProcedure.SelectedIndex = 0;

            ddlSecondaryProcedure.DataSource = dt;
            ddlSecondaryProcedure.DataTextField = "Name";
            ddlSecondaryProcedure.DataValueField = "Id";
            ddlSecondaryProcedure.DataBind();
            ddlSecondaryProcedure.Items.Insert(0, "select");
            ddlSecondaryProcedure.SelectedIndex = 0;

        }

    }
    private void BindSurgery()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT('CPT: ',im.ItemCode,' ',im.TypeName)Name,im.itemid Surgery_ID FROM f_itemmaster im INNER JOIN  f_subcategorymaster sm ON sm.SubCategoryID =im.SubCategoryID ");
        sb.Append(" INNER JOIN f_configrelation cf ON sm.categoryid = cf.categoryid AND cf.configID=25 AND cf.categoryid=46 WHERE sm.active=1 AND im.IsActive=1 ORDER BY im.TypeName ");
        DataTable dtSurgery = StockReports.GetDataTable(sb.ToString());

        // DataTable dtSurgery = StockReports.GetDataTable("select Surgery_ID, ltrim(Name) Name from f_surgery_master Where IsActive = 1 order by ltrim(Name)");

        if (dtSurgery.Rows.Count > 0)
        {
            ddlSurgery.DataSource = dtSurgery;
            ddlSurgery.DataTextField = "Name";
            ddlSurgery.DataValueField = "Surgery_ID";
            ddlSurgery.DataBind();
            ddlSurgery.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
    protected void ddlProcedure_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtProcedures.Text += "</br>"+(ddlProcedure.SelectedItem.Value).Replace("#", "'");
        txtProcedures.Focus();
    }
    protected void btnprint_Click(object sender, EventArgs e)
    {
        DataSet ds = new DataSet();
        DataTable dt = StockReports.GetDataTable(@"
            SELECT  PatientID,TransactionID,LedgerTransactionNo,SurgeonName1,SurgeonName2,AsstSurgeon1,AsstSurgeon2,Anesthetist,AsstAnesthetist,
        ScrubNurse,CirculNurse,SurgeryDate,Urgency,SurStartTime,SurFinishTime,PreOperatveDignose,Operation,Incisions1,Incisions2,
        Findings,Drains,Closure,Sample,Complication,BloodLoss,PostOprDignosis,PostOpInstruction,CreatedBy,CreatedDate,Ports,
        Procedures,AnesthesiaType,SurgeryID,SurgeryName,PrimaryProcedureVal,SecondaryProcedureVal,PrimaryProcedureText,SecondaryProcedureText,Department,WoundClassification,NatureOfSurgary,IsOtherSurgery,OtherSurgery
        FROM cpoe_OTNotes_DeptofSurgery 
             WHERE TransactionID='" + Request.QueryString["TransactionID"].ToString() + "'  ");
        ds.Tables.Add(dt.Copy());
        ds.Tables[0].TableName = "Departmentofsurgery";
        DataTable dtImg = All_LoadData.CrystalReportLogo();
        ds.Tables.Add(dtImg.Copy());
        ds.Tables[1].TableName = "logo";

      // ds.WriteXmlSchema(@"E:\Departmentofsurgery.xml");
        Session["ds"] = ds;
        Session["ReportName"] = "Departmentofsurgery";
        Session["ds"] = ds;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
    }
}