
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;
using System.Text;

using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;


public partial class Design_IPD_ICUNutritionAssessment : System.Web.UI.Page
{
    protected void Radio1_Changed(object sender, EventArgs e)
    {
       
    }
    protected void Radio11_Changed(object sender, EventArgs e)
    {

    }
    
    protected void Radio2_Changed(object sender, EventArgs e)
    {

       
    }
    protected void Radio3_Changed(object sender, EventArgs e)
    {

       
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtSignatureDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("hh:mm tt");
            ViewState["PID"] = Request.QueryString["PID"].ToString();
            ViewState["TID"] = Request.QueryString["TID"].ToString();

            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
        }
        string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        txtDate.Enabled = false;
        txtTime.Enabled = false;
        
        txtSignature.Text = entryby;

        txtSignature.Attributes.Add("readOnly", "true");
        //txtTotal.Enabled = false;
        //txtAssessmentBy.Text = entryby;
    }
    protected void grdPhysical_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       
    }
    
    protected void grdPhysical_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
                string ID1 = ((Label)grdPhysical.Rows[id].FindControl("lblID1")).Text;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('./ICUNutritionAssessment_PDF.aspx?TestID=O23&LabType=&LabreportType=11&ID=" + ID1 + "&TID=" + ViewState["TID"].ToString() + "');", true);

            
        }
        if (e.CommandName == "Change")
        {
            
            lblMsg.Text = "";
            int id = Convert.ToInt16(e.CommandArgument.ToString());
            lblID.Text = ((Label)grdPhysical.Rows[id].FindControl("lblID")).Text;

            DataTable dt = (DataTable)ViewState["dt"];
            DataRow[] rows = dt.Select("Id = '" + lblID.Text + "'");
            if (rows.Length > 0)
            {
                txtDate.Text = rows[0]["Date1"].ToString();
                txtTime.Text = rows[0]["Time1"].ToString();
                rdbNutritional.SelectedValue = rows[0]["Nutritional"].ToString();
                rdbSuspected.SelectedValue = rows[0]["Suspected"].ToString();
                rdbSuboptimal.SelectedValue = rows[0]["Suboptimal"].ToString();
                rdbWeightLoss.SelectedValue = rows[0]["Weight"].ToString();
                rdbMetabolic.SelectedValue = rows[0]["Metabolic"].ToString();
                rdbSubstance.SelectedValue = rows[0]["Substance"].ToString();
                rdbOther.SelectedValue = rows[0]["Other"].ToString();
                rdbNutritionRisk.SelectedValue = rows[0]["Nutrition"].ToString();
                txtHt.Text = rows[0]["Ht"].ToString();
                txtWt.Text = rows[0]["Wt"].ToString();
                txtCorrectedWt.Text = rows[0]["CorrectedWt"].ToString();

                rdbTiming.SelectedValue = rows[0]["Timing"].ToString();
                rdbRoute.SelectedValue = rows[0]["Route"].ToString();
                txtFinal1.Text = rows[0]["Final1"].ToString();
                txtFinal2.Text = rows[0]["Final2"].ToString();
                txtFinal3.Text = rows[0]["Final3"].ToString();
                txtRefeeding1.Text = rows[0]["Refeeding1"].ToString();
                txtRefeeding2.Text = rows[0]["Refeeding2"].ToString();
                txtRefeeding3.Text = rows[0]["Refeeding3"].ToString();
                txtRefeeding4.Text = rows[0]["Refeeding4"].ToString();
                txtRefeeding5.Text = rows[0]["Refeeding5"].ToString();
                txtProtein1.Text = rows[0]["Protein1"].ToString();
                if (rows[0]["Protein2"].ToString() == "1")
                {
                    chkProtein2.Checked = true;
                }
                else
                {
                    chkProtein2.Checked = false;
                }
                txtProtein3.Text = rows[0]["Protein3"].ToString();
                rdbFormula1.SelectedValue = rows[0]["Formula1"].ToString();
                txtGoal1.Text = rows[0]["Goal1"].ToString();
                txtGoal2.Text = rows[0]["Goal2"].ToString();
                txtGoal3.Text = rows[0]["Goal3"].ToString();
                txtGoal4.Text = rows[0]["Goal4"].ToString();
                rdbRecommended.SelectedValue = rows[0]["Recommended"].ToString();
                txtProblem.Text = rows[0]["Problem"].ToString();
                txtPlan.Text = rows[0]["Plan"].ToString();
                txtAction.Text = rows[0]["Action"].ToString();
                txtSignature.Text = rows[0]["Signature1"].ToString();
                txtSignatureDate.Text = rows[0]["SignatureDate1"].ToString();
            
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                btnCancel.Visible = true;
            }
            
        }
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindData(string PID, string TID)
    {
        string retn = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select *,DATE_FORMAT(Date, '%d %b %Y') as Date1,TIME_FORMAT(Time, '%h:%i %p') as Time1,TIMESTAMPDIFF(MINUTE,CreatedDate,NOW()) Enabled from painmanagementtoolneonatal where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc limit 1");
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            retn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retn;
        }
        else
        {
            return retn;
        }
    }
    public void BindDetails(string PID,string TID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Select *,(Select concat(title,' ',name) from Employee_master where EmployeeID=iu.Signature)Signature1,(Select concat(title,' ',name) from Employee_master where EmployeeID=iu.CreatedBy)EmpName,DATE_FORMAT(Date, '%d %b %Y') as Date1,DATE_FORMAT(SignatureDate, '%d %b %Y') as SignatureDate1,TIME_FORMAT(Time, '%h:%i %p') as Time1 from ICUNutritionAssessment iu where PatientID='" + PID + "' and TransactionID='" + TID + "' order by ID desc ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                ViewState["dt"] = dt;
                grdPhysical.DataSource = dt;
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


    
    protected void btnSave_Click(object sender, EventArgs e)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string signaturedate = Util.GetDateTime(txtSignatureDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            string protein2 = "0";
            if (chkProtein2.Checked == true)
            {
                protein2 = "1";
            }
                var sqlCMD = "INSERT INTO icunutritionassessment ("+
  
  "Date,  Time,  Nutritional,  Suspected,  Suboptimal,  Weight,  Metabolic,  Substance,  Other,  Nutrition,  Ht,  Wt,  CorrectedWt,  Timing,  Route, Final1,  Final2,  Final3,  Refeeding1,"+
"  Refeeding2,  Refeeding3,  Refeeding4,  Refeeding5,  Protein1,  Protein2,  Protein3,  Formula1,Formula2,  Goal1,  Goal2,  Goal3,  Goal4,  Recommended,  Problem,  Plan,  Action,  Signature,  SignatureDate," +
"  CreatedBy, CreatedDate,   PatientID,  TransactionID)"+
" VALUES  (        @Date,    @Time,    @Nutritional,    @Suspected,    @Suboptimal,    @Weight,    @Metabolic,    @Substance,   @Other,    @Nutrition,    @Ht,    @Wt,    @CorrectedWt,    @Timing,"+
"    @Route,    @Final1,    @Final2,    @Final3,    @Refeeding1,    @Refeeding2,    @Refeeding3,    @Refeeding4,    @Refeeding5,   @Protein1,    @Protein2,    @Protein3,    @Formula1,"+
"  @Formula2,  @Goal1,    @Goal2,    @Goal3,   @Goal4,    @Recommended,    @Problem,    @Plan,    @Action,    @Signature,    @SignatureDate,    @CreatedBy,   Now(),   @PatientID,    @TransactionID  );";       
            excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    Date = date,
                    Time = time,
                    Nutritional = rdbNutritional.SelectedValue,
                    Suspected = rdbSuspected.SelectedValue,
                    Suboptimal = rdbSuboptimal.SelectedValue,
                    Weight = rdbWeightLoss.SelectedValue,
                    Metabolic = rdbMetabolic.SelectedValue,
                    Substance = rdbSubstance.SelectedValue,
                    Other = rdbOther.SelectedValue,
                    Nutrition = rdbNutritionRisk.SelectedValue,
                    Ht = txtHt.Text,
                    Wt = txtWt.Text,
                    CorrectedWt = txtCorrectedWt.Text,
                    Timing = rdbTiming.SelectedValue,
                    Route = rdbRoute.SelectedValue,
                    Final1 = txtFinal1.Text,
                    Final2 = txtFinal2.Text,
                    Final3 = txtFinal3.Text,
                    Refeeding1 = txtRefeeding1.Text,
                    Refeeding2 = txtRefeeding2.Text,
                    Refeeding3 = txtRefeeding3.Text,
                    Refeeding4 = txtRefeeding4.Text,
                    Refeeding5 = txtRefeeding5.Text,
                    Protein1 = txtProtein1.Text,
                    Protein2 = protein2,
                    Protein3 = txtProtein3.Text,
                    Formula1 = rdbFormula1.SelectedValue,
                    Formula2 = txtFormula2.Text,
                    Goal1 = txtGoal1.Text,
                    Goal2 = txtGoal2.Text,
                    Goal3 = txtGoal1.Text,
                    Goal4 = txtGoal4.Text,
                    Recommended = rdbRecommended.SelectedValue,
                    Problem = txtProblem.Text,

                    Plan = txtPlan.Text,
                    Action = txtAction.Text,
                    Signature = HttpContext.Current.Session["ID"].ToString(),
                    SignatureDate = signaturedate,
                    CreatedBy = HttpContext.Current.Session["ID"].ToString(),
                    PatientID = ViewState["PID"].ToString(),
                    TransactionID = ViewState["TID"].ToString()
                });
                message = "Record Save Sucessfully";
                Clear();

            tnx.Commit();
            BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " modelAlert('"+message+"',function(){});", true);

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);

            lblMsg.Text = "Error occurred, Please contact Administrator";
          }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private void Clear()
    {

                    txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                    txtTime.Text = DateTime.Now.ToString("hh:mm tt");
                    rdbNutritional.SelectedIndex = -1;
                    rdbSuspected.SelectedIndex = -1;
                    rdbSuboptimal.SelectedIndex = -1;
                    rdbWeightLoss.SelectedIndex = -1;
                    rdbMetabolic.SelectedIndex =-1;
                    rdbSubstance.SelectedIndex = -1;
                    rdbOther.SelectedIndex =-1;
                    rdbNutritionRisk.SelectedIndex = -1;
                    txtHt.Text ="";
                    txtWt.Text ="";
                    txtCorrectedWt.Text = "";

                    rdbTiming.SelectedIndex = -1;
                    rdbRoute.SelectedIndex = -1;
                    txtFinal1.Text ="";
                    txtFinal2.Text = "";
                    txtFinal3.Text = "";
                    txtRefeeding1.Text = "";
                    txtRefeeding2.Text = "";
                    txtRefeeding3.Text = "";
                    txtRefeeding4.Text = "";
                    txtRefeeding5.Text = "";
                    txtProtein1.Text ="";
                        chkProtein2.Checked = false;
                    
                    txtProtein3.Text = "";
                    rdbFormula1.SelectedIndex = -1;
                    txtGoal1.Text ="";
                    txtGoal2.Text = "";
                    txtGoal3.Text = "";
                    txtGoal4.Text ="";
                    rdbRecommended.SelectedIndex = -1;
                    txtProblem.Text ="";
                    txtPlan.Text = "";
                    txtAction.Text = "";
                    txtSignatureDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           
                    string entryby = StockReports.ExecuteScalar("SELECT Name 	FROM 	employee_master  WHERE  EmployeeId='"+Session["ID"].ToString()+"' LIMIT 0, 1");
        
                    txtSignature.Text = entryby;


                            //txtCheckedBy.Text = HttpContext.Current.Session["ID"].ToString();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            var message = "";
            string date = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
            string time = Util.GetDateTime(txtTime.Text).ToString("HH:mm");
            string signaturedate = Util.GetDateTime(txtSignatureDate.Text).ToString("yyyy-MM-dd");
            string protein2 = "0";
            if (chkProtein2.Checked == true)
            {
                protein2 = "1";
            }

            var sqlCMD = "UPDATE ICUNutritionAssessment SET Date=@Date,Time=@Time,UpdateDate=NOW(),UpdatedBy=@UpdatedBy,Nutritional=@Nutritional," +
                "Suspected=@Suspected,Suboptimal=@Suboptimal,Weight=@Weight,Metabolic=@Metabolic," +
                "Substance=@Substance,Other=@Other,Nutrition=@Nutrition,Ht=@Ht,Wt=@Wt,CorrectedWt=@CorrectedWt," +
                "Timing=@Timing,Route=@Route,Final1=@Final1,Final2=@Final2," +
                "Final3=@Final3,Refeeding1=@Refeeding1,Refeeding2=@Refeeding2,Refeeding3=@Refeeding3,Refeeding4=@Refeeding4,Refeeding5=@Refeeding5,Protein1=@Protein1," +
                "Protein2=@Protein2,Protein3=@Protein3,Formula1=@Formula1,Formula2=@Formula2,Goal1=@Goal1,Goal2=@Goal2,Goal3=@Goal3,Goal4=@Goal4,Recommended=@Recommended," +
                    "Problem=@Problem,Plan=@Plan,Action=@Action" +
                    " WHERE ID=@ID;";
                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {

                    
                    UpdatedBy = HttpContext.Current.Session["ID"].ToString(),
                    Date = date,
                    Time = time,
                    Nutritional = rdbNutritional.SelectedValue,
                    Suspected = rdbSuspected.SelectedValue,
                    Suboptimal = rdbSuboptimal.SelectedValue,
                    Weight = rdbWeightLoss.SelectedValue,
                    Metabolic = rdbMetabolic.SelectedValue,
                    Substance = rdbSubstance.SelectedValue,
                    Other = rdbOther.SelectedValue,
                    Nutrition = rdbNutritionRisk.SelectedValue,
                    Ht = txtHt.Text,
                    Wt = txtWt.Text,
                    CorrectedWt = txtCorrectedWt.Text,
                    Timing = rdbTiming.SelectedValue,
                    Route = rdbRoute.SelectedValue,
                    Final1 = txtFinal1.Text,
                    Final2 = txtFinal2.Text,
                    Final3 = txtFinal3.Text,
                    Refeeding1 = txtRefeeding1.Text,
                    Refeeding2 = txtRefeeding2.Text,
                    Refeeding3 = txtRefeeding3.Text,
                    Refeeding4 = txtRefeeding4.Text,
                    Refeeding5 = txtRefeeding5.Text,
                    Protein1 = txtProtein1.Text,
                    Protein2 = protein2,
                    Protein3 = txtProtein3.Text,
                    Formula1 = rdbFormula1.SelectedValue,
                    Formula2 = txtFormula2.Text,
                    Goal1 = txtGoal1.Text,
                    Goal2 = txtGoal2.Text,
                    Goal3 = txtGoal1.Text,
                    Goal4 = txtGoal4.Text,
                    Recommended = rdbRecommended.SelectedValue,
                    Problem = txtProblem.Text,

                    Plan = txtPlan.Text,
                    Action = txtAction.Text,
                    
                    ID = Util.GetInt(lblID.Text)
                     });
                message = "Record Update Successfully";
                Clear();
                btnUpdate.Visible = false;
                btnSave.Visible = true;    
                tnx.Commit();

                BindDetails(ViewState["PID"].ToString(), ViewState["TID"].ToString());
            lblMsg.Text = message;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact Administrator";
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
    }
}