using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Collections.Generic;


public partial class Design_IPD_Partograph : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        if (!IsPostBack)
        {
            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            txtDilationDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtDilationTime.Text = DateTime.Now.ToString("hh:mm tt");

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["UserID"] = Session["ID"].ToString();
            string a = ViewState["ID"].ToString();
            string TID = Request.QueryString["TransactionID"].ToString();

            ViewState["TransID"] = TID;
            ViewState["Transaction_ID"] = TID;
            ViewState["PatientID"] = Request.QueryString["PatientID"].ToString();
            grdPartographbind();
           
           

            if (TID.Contains("ISHHI"))
            {
                dt = AllLoadData_IPD.getAdmitDischargeData(ViewState["Transaction_ID"].ToString());
                clcAppDate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);
                caldate.StartDate = Util.GetDateTime(dt.Rows[0]["DateofAdmit"]);

                if (dt.Rows[0]["Status"].ToString() == "OUT")
                {
                    caldate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);                   
                    clcAppDate.EndDate = Util.GetDateTime(dt.Rows[0]["DateofDischarge"]);
                    Btnsave.Visible = false;
                    btnUpdate.Visible = false;
                    btnCancel.Visible = false;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key66", " $('#btnCervixDescentsave').hide();", true);
                }
                else
                {
                    clcAppDate.EndDate = DateTime.Now;
                    caldate.EndDate = DateTime.Now;
                }
                txtDate1.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                caldate.EndDate = DateTime.Now;
            }

            DataTable dtCount = StockReports.GetDataTable("SELECT COUNT(1)COUNT FROM ipd_patient_partograph WHERE Transactionid='" + Util.GetString(ViewState["Transaction_ID"]).Trim() + "' ");
            if (dtCount.Rows[0]["COUNT"].ToString() != "0")
                divCervixDescent.Visible = false;
            else
                CervixDescenEntryDiv.Visible = false;

        }
        txtDate.Attributes.Add("readOnly", "readOnly");
        txtDilationDate.Attributes.Add("readOnly", "readOnly");
        txtDate1.Attributes.Add("readOnly", "true");
    }

    private void Clear()
    {
        divCervixDescent.Visible = false;
        CervixDescenEntryDiv.Visible = true;
        txtDate.Text = txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtTime.Text = DateTime.Now.Hour + ":" + DateTime.Now.Minute;
        txtDilationDate.Text = txtDilationDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtDilationTime.Text = DateTime.Now.Hour + ":" + DateTime.Now.Minute;
        txtGravida.Text = "";
        txtPara.Text = "";
        txtFHR.Text = "";
        txtTemp.Text = "";
        txtBP.Text = "";
        txtPulse.Text = "";
        ddlAmnioticFluid.ClearSelection();
        ddlMoulding.ClearSelection();
        ddlCervix.ClearSelection();
        ddlDescent.ClearSelection();
        ddlContractions.ClearSelection();
        ddlContraLasting.ClearSelection();
        txtOxyinML.Text = "";
        txtOxydrops.Text = "";
        ddlUrineProtein.ClearSelection();
        txtUrineVol.Text = "";
        ddlUrineKetones.ClearSelection();
        txtDrugs.Text = "";
        txtFluids.Text = "";
        lblMsg.Text = "";

       
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            double Temp;
            string TempConvert = string.Empty;
           
            Temp = ((Util.GetDouble(txtTemp.Text.Trim()) * (1.8)) + 32);
            TempConvert = txtTemp.Text.Trim();

            DataTable dtCount = StockReports.GetDataTable("SELECT COUNT(1)COUNT FROM ipd_patient_partograph WHERE Transactionid='" + Util.GetString(ViewState["Transaction_ID"]).Trim() + "' ");
            int Count = Util.GetInt(dtCount.Rows[0]["COUNT"].ToString());

            string str = "insert into ipd_patient_Partograph (Patient_ID,TransactionID,Date,Time,DilationDate,DilationTime,Gravida,Para,FHR,Temp,Bp,Pulse,AMF,Moulding,Cervix,Descent,"+
                "Contractions,Lasting,OxyinML,Oxydrops,UrineProtein,UrineVol,UrineKetones,Drugs,Fluids,CreatedBy,CreatedDate)"
                      + " Values ('" + Util.GetString(ViewState["PatientID"]).Trim() + "','" + Util.GetString(ViewState["Transaction_ID"]).Trim() + "','" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "', "
                      + " '" + Util.GetDateTime(txtDilationDate.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtDilationTime.Text).ToString("HH:mm") + "','" + txtGravida.Text.Trim() + "', "
                      + " '" + txtPara.Text.Trim() + "','" + txtFHR.Text.Trim() + "','" + TempConvert + "','" + txtBP.Text.Trim() + "','" + txtPulse.Text.Trim() + "', "
                      + " '" + ddlAmnioticFluid.SelectedItem.Value + "','" + ddlMoulding.SelectedItem.Value + "','" + ddlCervix.SelectedItem.Value + "','" + ddlDescent.SelectedItem.Value + "', "
                      + " '" + ddlContractions.SelectedItem.Value + "','" + ddlContraLasting.SelectedItem.Value + "','" + txtOxyinML.Text.Trim() + "','" + txtOxydrops.Text.Trim() + "', "
                      + " '" + ddlUrineProtein.SelectedItem.Value + "','" + txtUrineVol.Text.Trim() + "','" + ddlUrineKetones.SelectedItem.Value + "','" + txtDrugs.Text.Trim() + "',  "
                      + " '" + txtFluids.Text.Trim() + "','" + ViewState["UserID"] + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' )";                    
                    
            StockReports.ExecuteDML(str);

            if (Count == 0)
            {
                RecordsInsertintoCervixDescentTable(); 
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave", "modelAlert('Record Saved Successfully');", true);
            grdPartographbind();
            Clear();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error Occurred. Contact to Administrator.";
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave", "modelAlert('Error Occurred. Contact to Administrator.');", true);
        }
    }

    private void RecordsInsertintoCervixDescentTable()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string query = string.Empty; string Cervix = string.Empty; string Descent = string.Empty; string UserID = string.Empty;

            if (ddlCervix.SelectedItem.Value == "Select")
                Cervix = "0";
            else
                Cervix = ddlCervix.SelectedItem.Value;

            if (ddlDescent.SelectedItem.Value == "Select")
                Descent = "0";
            else
                Descent = ddlDescent.SelectedItem.Value;

            if (ddlCervix.SelectedItem.Value == "Select" && ddlDescent.SelectedItem.Value == "Select")
                UserID = "";
            else
                UserID = ViewState["UserID"].ToString();	

            for (int i = 0; i < 11; i++)
            {
                query = " INSERT INTO ipd_patient_partograph_CervixDescent(TransactionID,CreatedDate,EntDate,EntTime,Cervix,Descent,Alert,Action,CreatedBy )  ";
                query += " VALUE('" + Util.GetString(ViewState["Transaction_ID"]).Trim() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "', ";

                switch (i)
                {
                    case (0):
                        {
                            query += " '" + DateTime.Now.ToString("yyyy-MM-dd") + "','" + DateTime.Now.ToString("HH:mm") + "','" + Cervix + "','" + Descent + "', ";
                            query += " '4','0','" + UserID + "') ";
                            break;
                        }
                    case (1):
                        {
                            query += " '" + DateTime.Now.AddHours(1).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(1).ToString("HH:mm") + "','','','5','0','' ) ";
                            break;
                        }
                    case (2):
                        {
                            query += " '" + DateTime.Now.AddHours(2).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(2).ToString("HH:mm") + "','','','6','0','' ) ";
                            break;
                        }
                    case (3):
                        {
                            query += " '" + DateTime.Now.AddHours(3).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(3).ToString("HH:mm") + "','','','7','0','' ) ";
                            break;
                        }
                    case (4):
                        {
                            query += " '" + DateTime.Now.AddHours(4).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(4).ToString("HH:mm") + "','','','8','4','' ) ";
                            break;
                        }
                    case (5):
                        {
                            query += " '" + DateTime.Now.AddHours(5).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(5).ToString("HH:mm") + "','','','9','5','' ) ";
                            break;
                        }
                    case (6):
                        {
                            query += " '" + DateTime.Now.AddHours(6).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(6).ToString("HH:mm") + "','','','10','6','' ) ";
                            break;
                        }
                    case (7):
                        {
                            query += " '" + DateTime.Now.AddHours(7).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(7).ToString("HH:mm") + "','','','0','7','' ) ";
                            break;
                        }
                    case (8):
                        {
                            query += " '" + DateTime.Now.AddHours(8).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(8).ToString("HH:mm") + "','','','0','8','' ) ";
                            break;
                        }
                    case (9):
                        {
                            query += " '" + DateTime.Now.AddHours(9).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(9).ToString("HH:mm") + "','','','0','9','' ) ";
                            break;
                        }
                    case (10):
                        {
                            query += " '" + DateTime.Now.AddHours(10).ToString("yyyy-MM-dd") + "','" + DateTime.Now.AddHours(10).ToString("HH:mm") + "','','','0','10','' ) ";
                            break;
                        }
                }
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, query);
            }
            tranX.Commit();
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    private DataTable Search()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT   ipo.Induction,  ipo.Duration,  ipo.NoOfVE,  ipo.Hours,  ipo.Mins,  ipo.Mode1,  ipo.Duration1,  ipo.mins1,  ipo.AMTSL,  ipo.Uterotonic, ipo.Duration2,  ipo.Alive,  ipo.M,"+
"  ipo.ApgarScore1Min, ipo.ApgarScore5Min,  ipo.ApgarScore10Min,  ipo.Resusation,  ipo.Duration3,  ipo.Mins3, ipo.Placenta,  ipo.Membranes, ipo.Cord,  ipo.PlacentaWt, ipo.EstBloodLoss,  ipo.Devinial,"+
"  ipo.BP1,  ipo.Pulse1,  ipo.Temp1,  ipo.Resp1,  ipo.Length1,  ipo.Weight, ipo.HC,  ipo.DrugsGiven, (SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID= ipo.DeliveryBy)DeliveryBy1,ipo.ID,ipo.Patient_ID,REPLACE(ipo.TransactionID,'ISHHI','')IPDNo,DATE_FORMAT(ipo.DATE,'%d-%b-%Y') AS DATE,DATE_FORMAT(ipo.Time, '%l:%i %p')TIME, ");
        sb.Append(" DATE_FORMAT(ipo.DilationDate,'%d-%b-%Y')DilationDate,DATE_FORMAT(ipo.DilationTime,'%l:%i %p')DilationTime,ipo.Gravida,ipo.Para,ipo.FHR,FORMAT(ipo.Temp,1)Temp,ipo.BP, ");
        sb.Append(" FORMAT(ipo.pulse,0)pulse,IF(ipo.AMF='Select','',ipo.AMF)AMF,IF(ipo.Moulding='Select','',ipo.Moulding)Moulding,IF(ipo.Cervix='Select','',ipo.Cervix)Cervix, ");
        sb.Append(" IF(ipo.Descent='Select','',ipo.Descent)Descent,IF(ipo.Contractions='Select','',ipo.Contractions)Contractions,IF(ipo.Lasting='Select','',ipo.Lasting)Lasting,");
        sb.Append(" ipo.OxyinML,ipo.Oxydrops,IF(ipo.UrineProtein='Select','',ipo.UrineProtein)UrineProtein,ipo.UrineVol,IF(ipo.UrineKetones='Select','',ipo.UrineKetones)UrineKetones, ");
        sb.Append(" ipo.Drugs,ipo.Fluids,ipo.CreatedBy,  ");
        sb.Append(" (SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=ipo.CreatedBy)EmpName, ");
        sb.Append(" CONCAT(dm.title,'',dm.name) AS DoctorName, ");
        sb.Append(" CONCAT(pm.Title,'',pm.PName) AS PatientName,pmh.DateOfVisit,CONCAT(em.title,'',em.name) AS Username, ");
        sb.Append(" TIMESTAMPDIFF(MINUTE,ipo.CreatedDate,NOW())createdDateDiff  ");
        sb.Append(" FROM ipd_patient_Partograph ipo  ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.PatientID = ipo.Patient_ID  ");
        sb.Append(" INNER JOIN Doctor_master dm ON dm.doctorID = pmh.DoctorID  ");
        sb.Append(" INNER JOIN patient_master pm ON pm.patientID = pmh.PatientID  ");
        sb.Append(" LEFT JOIN employee_master em ON em.employeeID = ipo.CreatedBy  ");
        sb.Append(" WHERE ipo.transactionID = '" + ViewState["Transaction_ID"] + "' GROUP BY ipo.ID ORDER BY ipo.Date DESC,ipo.time DESC  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return dt;
    }
    public void grdPartographbind()
    {
        DataTable dt = Search();
        grdNursing.DataSource = dt;
        grdNursing.DataBind();
    }

    protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdNursing.PageIndex = e.NewPageIndex;
        DataTable dt = Search();
        grdNursing.DataSource = dt;
        grdNursing.DataBind();
    }

    protected void grdNursing_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            decimal createdDateDiff = Util.GetDecimal(((Label)e.Row.FindControl("lblTimeDiff")).Text);
            if (((Label)e.Row.FindControl("lblCreatedID")).Text != Session["ID"].ToString())
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = false;
                // ((ImageButton)e.Row.FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
            }
            else
            {
                ((ImageButton)e.Row.FindControl("imgbtnEdit")).Enabled = true;
            }
        }
    }

    protected void grdNursing_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Change")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            string UserID = ((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text;

            lblID.Text = ((Label)grdNursing.Rows[id].FindControl("lblID")).Text;

            DateTime dttime = Util.GetDateTime(((Label)grdNursing.Rows[id].FindControl("lbldate")).Text + " " + ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text);
            DateTime current = Util.GetDateTime(DateTime.Now);
            TimeSpan diff = current.Subtract(dttime);

            if (((Label)grdNursing.Rows[id].FindControl("lblUserID")).Text != Session["ID"].ToString())
            {
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).Enabled = false;
                ((ImageButton)grdNursing.Rows[id].FindControl("imgbtnEdit")).ToolTip = "Edit Time Period Expired";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('You are not right person to edit this Notes');", true);

            }
            else if (((diff.Days * 24) + diff.Hours) > 2)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Edit Time Period Expired You can edit only within two hours From Entry Date Time');", true);
            }
            else
            {
                txtDate.Text = ((Label)grdNursing.Rows[id].FindControl("lblDate")).Text;
                txtTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblTime")).Text; 
                txtDilationDate.Text = ((Label)grdNursing.Rows[id].FindControl("lblDilationDate")).Text;
                txtDilationTime.Text = ((Label)grdNursing.Rows[id].FindControl("lblDilationTime")).Text; 
                txtGravida.Text = ((Label)grdNursing.Rows[id].FindControl("lblGravida")).Text;
                txtPara.Text = ((Label)grdNursing.Rows[id].FindControl("lblPara")).Text;
                txtFHR.Text = ((Label)grdNursing.Rows[id].FindControl("lblFHR")).Text;
                txtTemp.Text = ((Label)grdNursing.Rows[id].FindControl("lblTemp")).Text;
                txtBP.Text = ((Label)grdNursing.Rows[id].FindControl("lblBP")).Text;
                txtPulse.Text = ((Label)grdNursing.Rows[id].FindControl("lblPulse")).Text;
                ddlAmnioticFluid.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblAMF")).Text;
                ddlMoulding.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblMoulding")).Text;
               // ddlCervix.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblCervix")).Text;
              //  ddlDescent.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblDescent")).Text;
                ddlContractions.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblContractions")).Text;
                ddlContraLasting.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblLasting")).Text;
                txtOxyinML.Text = ((Label)grdNursing.Rows[id].FindControl("lblOxyinML")).Text;
                txtOxydrops.Text = ((Label)grdNursing.Rows[id].FindControl("lblOxydrops")).Text;
                ddlUrineProtein.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblUrineProtein")).Text;
                txtUrineVol.Text = ((Label)grdNursing.Rows[id].FindControl("lblUrineVol")).Text;
                ddlUrineKetones.SelectedValue = ((Label)grdNursing.Rows[id].FindControl("lblUrineKetones")).Text;              
                txtDrugs.Text = ((Label)grdNursing.Rows[id].FindControl("lblDrugs")).Text;
                txtFluids.Text = ((Label)grdNursing.Rows[id].FindControl("lblFluids")).Text;

                

                btnUpdate.Visible = true;
                Btnsave.Visible = false;
                btnCancel.Visible = true;
            }


        }
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection(Util.GetConString());
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            double Temp;
            string TempConvert = string.Empty;           
            Temp = ((Util.GetDouble(txtTemp.Text.Trim()) * (1.8)) + 32);
            TempConvert = txtTemp.Text.Trim();

            string str =  " UPDATE ipd_patient_Partograph SET DATE='" + Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd") + "',TIME='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm") + "', ";
                   str += " DilationDate='" + Util.GetDateTime(txtDilationDate.Text).ToString("yyyy-MM-dd") + "',DilationTime='" + Util.GetDateTime(txtDilationTime.Text).ToString("HH:mm") + "', "; 
                   str += " Gravida='" + txtGravida.Text.Trim() + "',Para='" + txtPara.Text.Trim() + "',FHR='" + txtFHR.Text + "',Temp='" + TempConvert + "',Bp='" + txtBP.Text + "',Pulse='" + txtPulse.Text + "', "; 
                   str += " AMF='" + ddlAmnioticFluid.SelectedItem.Value + "',Moulding='" + ddlMoulding.SelectedItem.Value + "',Cervix='" + ddlCervix.SelectedItem.Value + "', "; 
                   str += " Descent='" + ddlDescent.SelectedItem.Value + "',Contractions='" + ddlContractions.SelectedItem.Value + "',Lasting='" + ddlContraLasting.SelectedItem.Value + "', ";
                   str += " OxyinML='" + txtOxyinML.Text.Trim() + "',Oxydrops='" + txtOxydrops.Text.Trim() + "',UrineProtein='" + ddlUrineProtein.SelectedItem.Value + "', ";
                   str += " UrineVol='" + txtUrineVol.Text.Trim() + "',UrineKetones='" + ddlUrineKetones.SelectedItem.Value + "',Drugs='" + txtDrugs.Text + "', ";
                   str += " Fluids='" + txtFluids.Text + "',LastUpdatedBy='" + ViewState["UserID"] + "',LastUpdatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm::ss")+"'";
                       str+= " WHERE ID='" + lblID.Text + "' ";
                    
            int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

            if (result == 1) 
               // ScriptManager.RegisterStartupScript(this, this.GetType(), "keySave", "modelAlert('Record Updated Successfully');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Updated Successfully');", true);
            tnx.Commit();
            grdPartographbind();
            Clear();

        }
        catch (Exception ex)
        {
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

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Clear();
        btnCancel.Visible = false;
        btnUpdate.Visible = false;
        Btnsave.Visible = true;
    }

    [WebMethod]
    public static string bindData(string TransID, string Date)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT IFNULL(ipp.EntDate,'')DATE,TIME_FORMAT(ipp.EntTime,'%h:%i %p')Time_Label,");
        sb.Append(" ipp.Cervix,ipp.Descent,ipp.Alert,ipp.Action,IFNULL(CONCAT(em.Title,' ',em.Name),'')Name,ipp.ID ");
        sb.Append(" FROM ipd_patient_partograph_CervixDescent ipp ");
        sb.Append(" LEFT JOIN employee_master em ON em.EmployeeID=ipp.CreatedBy ");
        // sb.Append(" WHERE DATE(ipp.EntDate)='" + Convert.ToDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd") + "' AND ipp.Transactionid='" + TransID + "' ");
        sb.Append(" WHERE ipp.Transactionid='" + TransID + "' ");

        DataTable dtDetails = StockReports.GetDataTable(sb.ToString());
        if (dtDetails.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetails);
        }
        return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Intake")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveData(object Intake, string PID, string TID)
    {
        List<Intake> intake = new JavaScriptSerializer().ConvertToType<List<Intake>>(Intake);
        if (intake.Count > 0)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                for (int i = 0; i < intake.Count; i++)
                {
                    /* if (intake[i].CreatedBy == "")
                       {
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "INSERT INTO ipd_patient_partograph_CervixDescent(Transaction_ID,EntDate,EntTime,Cervix,Descent,Alert,Action,CreatedBy,CreatedDate )  " +
                                " VALUE('" + TID + "','" + Util.GetDateTime(intake[i].Date).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(intake[i].Time).ToString("HH:mm:ss") + "', " +
                                " '" + intake[i].Cervix + "','" + intake[i].Descent + "','" + intake[i].Alert + "','" + intake[i].Action + "', " +
                                " '" + HttpContext.Current.Session["ID"].ToString() + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' )");                         
                       }
                       else if (intake[i].CreatedBy != null || intake[i].CreatedBy != "")
                       {
                           MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ipd_patient_partograph_CervixDescent SET Cervix = '" + intake[i].Cervix + "', Descent ='" + intake[i].Descent + "', CreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "', CreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE ID='" + intake[i].ID + "' AND TransactionID='" + TID + "' ");
                       } */

                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "UPDATE ipd_patient_partograph_CervixDescent SET Cervix = '" + intake[i].Cervix + "', Descent ='" + intake[i].Descent + "', CreatedBy='" + HttpContext.Current.Session["ID"].ToString() + "', CreatedDate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' WHERE ID='" + intake[i].ID + "' AND TransactionID='" + TID + "' ");

                }
                tranX.Commit();
                return "1";
            }
            catch (Exception ex)
            {
                tranX.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "0";
            }
            finally
            {
                tranX.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            return "";
        }
    }

    public class Intake
    {
        public string Cervix { get; set; }
        public string Descent { get; set; }
        public string Alert { get; set; }
        public string Action { get; set; }
        public string Time { get; set; }
        public string Date { get; set; }
        public string CreatedBy { get; set; }
        public string ID { get; set; }
    }

}