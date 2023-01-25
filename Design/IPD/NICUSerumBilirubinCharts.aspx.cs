using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using MySql.Data.MySqlClient;

public partial class Design_IPD_NICUSerumBilirubinCharts : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
            ViewState["UserID"] = Session["ID"].ToString();

            ViewState["PID"] = Request.QueryString["PatientID"].ToString();

            txtDOB.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt"); ;
            BindGraphTemp(ViewState["TID"].ToString());
        }
        txtDOB.Attributes.Add("readOnly", "true");
    }
    private void BindGraphTemp(string TID)
    {
        string str = "SELECT DATEDIFF(pli.ResultEnteredDate,ges.DateofBirth)Days,ges.DateofBirth,TimeofBirth,BabyBloodGroup,MotherBloodGroup,DirectTest,pli.ResultEnteredDate,obs.Value,WeeksGestation,(select concat(title,' ',Name) from employee_master where EmployeeID=ges.EntryBy)EntryBy,Date_Format(EntryDate,'%d-%b-%y %l:%i:%p')EntryDate FROM ipd_gestation ges INNER JOIN patient_labinvestigation_opd pli ON pli.TransactionID=ges.TransactionID";
        str += " INNER JOIN patient_labobservation_opd  obs ON obs.Test_ID=pli.Test_ID";
        str += " WHERE ges.TransactionID='" + TID + "' AND obs.LabObservation_ID='LSHHI127'  ";
        str += " AND DATEDIFF(pli.ResultEnteredDate,ges.DateofBirth)<=14";
        str += " ORDER BY pli.ResultEnteredDate";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            lblUpdatedBy.Text = "Last Updated By :" + dt.Rows[0]["EntryBy"].ToString() + " On " + dt.Rows[0]["EntryDate"].ToString();
            txtDOB.Text = Util.GetDateTime(dt.Rows[0]["DateofBirth"]).ToString("dd-MMM-yyyy");
            txtTime.Text = Util.GetDateTime(dt.Rows[0]["TimeofBirth"]).ToString("HH:mm");
            ddlgestationType.SelectedIndex = ddlgestationType.Items.IndexOf(ddlgestationType.Items.FindByValue(dt.Rows[0]["WeeksGestation"].ToString()));
            txtDirectTest.Text = dt.Rows[0]["DirectTest"].ToString();
            txtBabyBG.Text = dt.Rows[0]["BabyBloodGroup"].ToString();
            txtMotherBG.Text = dt.Rows[0]["MotherBloodGroup"].ToString();

            //txtDOB.Enabled = false;
            //txtTime.Enabled = false;
            //ddlgestationType.Enabled = false;
            //txtDirectTest.Enabled = false;
            //txtBabyBG.Enabled = false;
            //txtMotherBG.Enabled = false;

            //btnSave.Enabled = false;

            double minDays = Convert.ToDouble(dt.Compute("min(Days)", string.Empty));
            double maxDays = Convert.ToDouble(dt.Compute("max(Days)", string.Empty));

            chartGestation.DataSource = dt;
            chartGestation.Legends.Add("Gestation").Title = "Gestation Graph";
            chartGestation.ChartAreas["ChartArea1"].AxisX.Title = "Days from birth";

            chartGestation.ChartAreas["ChartArea1"].AxisX.Minimum = 0;
            chartGestation.ChartAreas["ChartArea1"].AxisX.Maximum = 14;
            chartGestation.ChartAreas["ChartArea1"].AxisY.Minimum = 0;
            chartGestation.ChartAreas["ChartArea1"].AxisY.Maximum = 550;

            chartGestation.ChartAreas["ChartArea1"].AxisY.Interval = 50;
            chartGestation.ChartAreas["ChartArea1"].AxisX.Interval = 1;
            chartGestation.ChartAreas["ChartArea1"].AxisY.Title = "Total serum bilirubin (micromol/litre)";
            chartGestation.Series["Total Serum Bilirubin"].XValueMember = "Days";
            chartGestation.Series["Total Serum Bilirubin"].YValueMembers = "Value";

            if (dt.Rows[0]["WeeksGestation"].ToString() == "35")
            {
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(0, 80);
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(3, 350);
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(14, 350);

                chartGestation.Series["Phototherapy"].Points.AddXY(0, 40);
                chartGestation.Series["Phototherapy"].Points.AddXY(3, 250);
                chartGestation.Series["Phototherapy"].Points.AddXY(14, 250);
            }
            else if (dt.Rows[0]["WeeksGestation"].ToString() == "30")
            {
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(0, 80);
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(3, 300);
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(14, 300);

                chartGestation.Series["Phototherapy"].Points.AddXY(0, 40);
                chartGestation.Series["Phototherapy"].Points.AddXY(3, 200);
                chartGestation.Series["Phototherapy"].Points.AddXY(14, 200);
            }
            else if (dt.Rows[0]["WeeksGestation"].ToString() == "38")
            {
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(0, 100);
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(1.8, 450);
                chartGestation.Series["Exchange Transfusion"].Points.AddXY(14, 450);

                chartGestation.Series["Phototherapy"].Points.AddXY(0, 100);
                chartGestation.Series["Phototherapy"].Points.AddXY(4, 350);
                chartGestation.Series["Phototherapy"].Points.AddXY(14, 350);
            }
            chartGestation.DataBind();
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ddlgestationType.SelectedItem.Value == "")
        {
            lblMsg.Text = "Select Gestation Weeks";
            ddlgestationType.Focus();
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string TransactionID = Request.QueryString["TransactionID"].ToString();
            if (TransactionID != "")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("Select COUNT(*) From ipd_gestation where TransactionID='" + TransactionID + "'  "));
                if (count > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update  ipd_gestation SET DateofBirth='" + Util.GetDateTime(txtDOB.Text).ToString("yyyy-MM-dd") + "',TimeOfBirth='" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "',BabyBloodGroup='" + txtBabyBG.Text.Trim() + "',MotherBloodGroup='" + txtMotherBG.Text.Trim() + "',DirectTest='" + txtDirectTest.Text.Trim() + "',WeeksGestation='" + ddlgestationType.SelectedItem.Value + "',EntryBy='" + ViewState["UserID"].ToString() + "',EntryDate=NOW() WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND PatientID='" + ViewState["PID"].ToString() + "'");
                }
                else
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO ipd_gestation(TransactionID,PatientID,DateofBirth,TimeOfBirth,BabyBloodGroup,MotherBloodGroup,DirectTest,WeeksGestation,EntryBy,EntryDate)VALUES('" + ViewState["TID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + Util.GetDateTime(txtDOB.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtTime.Text).ToString("HH:mm:ss") + "','" + txtBabyBG.Text.Trim() + "','" + txtMotherBG.Text.Trim() + "','" + txtDirectTest.Text.Trim() + "','" + ddlgestationType.SelectedItem.Value + "','" + ViewState["UserID"].ToString() + "',NOW())");
                }
                tnx.Commit();
                BindGraphTemp(ViewState["TID"].ToString());
                lblMsg.Text = "Record Saved Successfully";
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error occurred, Please contact administrator";
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
}