using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_EDP_CopyRates : System.Web.UI.Page
{
    protected void btncreateRateIPD_Click(object sender, EventArgs e)
    {
        ViewState["RateFor"] = "IPD";
        All_LoadData.BindPanelIPD(ddlPanel);
        BindFromCentreIPD();
        BindToCentreIPD();
        show();
        grdEditOPD.Visible = false;
        grdEditIPD.Visible = true;
        bindSubCategoryIPD();
        btnSave.Visible = true;
    }

    protected void btncreateRateOPD_Click(object sender, EventArgs e)
    {
        ViewState["RateFor"] = "OPD";
        All_LoadData.BindPanelOPD(ddlPanel);
        BindFromCentreOPD();
        BindToCentreOPD();
        bindSubCategory();
        show();
        grdEditIPD.Visible = false;
        grdEditOPD.Visible = true;
        btnSave.Visible = true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        Hide();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (grdEditOPD.Visible == true)
            {
                foreach (GridViewRow gr in grdEditOPD.Rows)
                {
                    if (((CheckBox)gr.FindControl("chkSelectOne")).Checked == true)
                    {
                        if (((DropDownList)gr.FindControl("ddlPlus")).SelectedItem.Text == "+")
                        {
                            string PanelID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Panelid from f_rate_schedulecharges where ScheduleChargeID='" + ddlCpyTo.SelectedItem.Value.ToString() + "'"));
                            string catID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT DISTINCT CategoryID FROM f_subcategorymaster WHERE SubCategoryID='" + ((Label)gr.FindControl("Cname")).Text + "'"));

                            string inst = "insert into f_ratelist (Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,ScheduleChargeID,userid,CentreID) SELECT ('L')Location,('SHHI')Hospcode,(Rate+((Rate*(" + Util.GetInt(((TextBox)gr.FindControl("txtOpdRate")).Text) + "))/100))Rate,fl.IsCurrent,fl.ItemID,(" + PanelID + ")PanelID,('" + ddlCpyTo.SelectedItem.Value.ToString() + "')ScheduleChargeID,('" + ViewState["UserID"].ToString() + "')userid,"+ddlCentreCopyto.SelectedValue+" FROM f_ratelist fl INNER JOIN f_itemmaster im ON fl.ItemID=im.ItemID INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID INNER JOIN f_configrelation con ON sm.categoryID=con.categoryID WHERE sm.DisplayName='" + ((Label)gr.FindControl("Cname")).Text + "' and fl.PanelID='" + ddlCpyFrm.SelectedItem.Value.ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, inst);
                        
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist SET RateListID=ConCAT(Location,Hospcode,ID)  WHERE IFNULL(RateListID,'')=''");

                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist) WHERE groupname='f_ratelist' ");


                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

                            Hide();
                        }

                        if (((DropDownList)gr.FindControl("ddlPlus")).SelectedItem.Text == "-")
                        {
                            string PanelID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Panelid from f_rate_schedulecharges where ScheduleChargeID='" + ddlCpyTo.SelectedItem.Value.ToString() + "'"));
                       
                            string catID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT DISTINCT CategoryID FROM f_subcategorymaster WHERE SubCategoryID='" + ((Label)gr.FindControl("Cname")).Text + "'"));
                            string inst = "insert into f_ratelist (Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,ScheduleChargeID,userid,CentreID) SELECT ('L')Location,('SHHI')Hospcode,(Rate-((Rate*(" + Util.GetInt(((TextBox)gr.FindControl("txtOpdRate")).Text) + "))/100))Rate,fl.IsCurrent,fl.ItemID,(" + PanelID + ")PanelID,('" + ddlCpyTo.SelectedItem.Value.ToString() + "')ScheduleChargeID,('" + ViewState["UserID"].ToString() + "')userid,"+ddlCentreCopyto.SelectedValue+" FROM f_ratelist fl INNER JOIN f_itemmaster im ON fl.ItemID=im.ItemID INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID INNER JOIN f_configrelation con ON sm.categoryID=con.categoryID WHERE sm.DisplayName='" + ((Label)gr.FindControl("Cname")).Text + "' and fl.PanelID='" + ddlCpyFrm.SelectedItem.Value.ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, inst);
                        
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist SET RateListID=ConCAT(Location,Hospcode,ID)  WHERE IFNULL(RateListID,'')=''");

                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist) WHERE groupname='f_ratelist' ");


                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

                            Hide();
                        }
                    }
                }
            }

            if (grdEditIPD.Visible == true)
            {
                foreach (GridViewRow gr in grdEditIPD.Rows)
                {
                    if (((CheckBox)gr.FindControl("chkSelectOne")).Checked == true)
                    {
                        if (((DropDownList)gr.FindControl("ddlPlus2")).SelectedItem.Text == "+")
                        {
                            string PanelID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Panelid from f_rate_schedulecharges where ScheduleChargeID='" + ddlCpyTo.SelectedItem.Value.ToString() + "'"));
                            string catID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text,  "SELECT DISTINCT CategoryID FROM f_subcategorymaster WHERE SubCategoryID='" + ((Label)gr.FindControl("Cnameipd")).Text + "'"));

                            if (((Label)gr.FindControl("lblConfigID")).Text != "22")
                            {
                                string inst = "insert into f_ratelist_ipd (Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,IPDCaseType_ID,ScheduleChargeID,userid,CentreID) SELECT ('L')Location,('SHHI')Hospcode,(Rate+((Rate*(" + Util.GetInt(((TextBox)gr.FindControl("txtIpdRate")).Text) + "))/100))Rate,fl.IsCurrent,fl.ItemID,(" + PanelID + ")PanelID,IPDCaseType_ID,('" + ddlCpyTo.SelectedItem.Value.ToString() + "')ScheduleChargeID,('" + ViewState["UserID"].ToString() + "')userid,"+ddlCentreCopyto.SelectedValue+" FROM f_ratelist_ipd fl INNER JOIN f_itemmaster im ON fl.ItemID=im.ItemID INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID INNER JOIN f_configrelation con ON sm.categoryID=con.categoryID WHERE sm.DisplayName='" + ((Label)gr.FindControl("Cnameipd")).Text + "' and fl.PanelID='" + ddlCpyFrm.SelectedItem.Value.ToString() + "'";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, inst);
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist_ipd SET RateListID=ConCAT(Location,Hospcode,ID)  WHERE IFNULL(RateListID,'')=''");

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd' ");

                            }
                            else
                            {
                                string IPDSurgery = "insert into f_surgery_rate_list (Rate,IsCurrent,PanelID,IPDCaseType_ID,ScheduleChargeID,UserID,CentreID)SELECT (Rate+((Rate*(" + Util.GetInt(((TextBox)gr.FindControl("txtIpdRate")).Text) + "))/100))Rate, fl.IsCurrent,(" + PanelID + ")PanelID,IPDCaseType_ID,('" + ddlCpyTo.SelectedItem.Value.ToString() + "')ScheduleChargeID,('" + ViewState["UserID"].ToString() + "')userid," + ddlCentreCopyto.SelectedValue + " FROM f_surgery_rate_list  fl  WHERE fl.PanelID='" + ddlCpyFrm.SelectedItem.Value.ToString() + "'";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, IPDSurgery);
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_surgery_rate_list SET Surgery_ID=ConCAT('L','SHHI',ID)  WHERE IFNULL(Surgery_ID,'')=''");
                            }
                            Hide();
                        }

                        if (((DropDownList)gr.FindControl("ddlPlus2")).SelectedItem.Text == "-")
                        {
                           
                            string PanelID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Panelid from f_rate_schedulecharges where ScheduleChargeID='" + ddlCpyTo.SelectedItem.Value.ToString() + "'"));
                            string catID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT DISTINCT CategoryID FROM f_subcategorymaster WHERE SubCategoryID='" + ((Label)gr.FindControl("Cnameipd")).Text + "'"));

                            if (((Label)gr.FindControl("lblConfigID")).Text != "22")
                            {
                                string inst = "insert into f_ratelist_ipd (Location,Hospcode,Rate,IsCurrent,ItemID,PanelID,IPDCaseType_ID,ScheduleChargeID,userid,CentreId) SELECT ('L')Location,('SHHI')Hospcode,(Rate-((Rate*(" + Util.GetInt(((TextBox)gr.FindControl("txtIpdRate")).Text) + "))/100))Rate,fl.IsCurrent,fl.ItemID,(" + PanelID + ")PanelID,IPDCaseType_ID,('" + ddlCpyTo.SelectedItem.Value.ToString() + "')ScheduleChargeID,('" + ViewState["UserID"].ToString() + "')userid," + ddlCentreCopyto.SelectedValue + " FROM f_ratelist_ipd fl INNER JOIN f_itemmaster im ON fl.ItemID=im.ItemID INNER JOIN f_subcategorymaster sm ON im.SubCategoryID=sm.SubCategoryID INNER JOIN f_configrelation con ON sm.categoryID=con.categoryID WHERE sm.DisplayName='" + ((Label)gr.FindControl("Cnameipd")).Text + "' and fl.PanelID='" + ddlCpyFrm.SelectedItem.Value.ToString() + "'";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, inst);

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ratelist_ipd SET RateListID=ConCAT(Location,Hospcode,ID)  WHERE IFNULL(RateListID,'')=''");
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE id_master SET MaxID=(Select max(ID) FROM f_ratelist_ipd) WHERE groupname='f_ratelist_ipd' ");

                            }
                            else
                            {
                                string IPDSurgery = "insert into f_surgery_rate_list (Rate,IsCurrent,PanelID,IPDCaseType_ID,ScheduleChargeID,UserID,CentreId)SELECT (Rate-((Rate*(" + Util.GetInt(((TextBox)gr.FindControl("txtIpdRate")).Text) + "))/100))Rate, fl.IsCurrent,(" + PanelID + ")PanelID,IPDCaseType_ID,('" + ddlCpyTo.SelectedItem.Value.ToString() + "')ScheduleChargeID,('" + ViewState["UserID"].ToString() + "')userid," + ddlCentreCopyto.SelectedValue + " FROM f_surgery_rate_list  fl  WHERE fl.PanelID='" + ddlCpyFrm.SelectedItem.Value.ToString() + "'";
                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, IPDSurgery);

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_surgery_rate_list SET Surgery_ID=ConCAT('L','SHHI',ID)  WHERE IFNULL(Surgery_ID,'')=''");

                            }
                            Hide();
                        }
                    }
                }
            }
            Tnx.Commit();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }

        if (grdEditOPD.Visible == true)
        {
            grdEditOPD.Visible = false;
            btnSave.Visible = false;
        }
        if (grdEditIPD.Visible == true)
        {
            grdEditIPD.Visible = false;
            btnSave.Visible = false;
        }
    }

    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ViewState["RateFor"].ToString() == "OPD")
        {
            BindFromCentreOPD();
            BindToCentreOPD();
        }
        else if (ViewState["RateFor"].ToString() == "IPD")
        {
            BindFromCentreIPD();
            BindToCentreIPD();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["UserID"] = Session["ID"].ToString();
        }

        lblMsg.Text = "";
    }

    private void bindSubCategory()
    {

        string str = "SELECT  DisplayName,SubCategoryID FROM f_subcategorymaster WHERE Active=1 GROUP BY DisplayName";

        DataTable dt = StockReports.GetDataTable(str);
        grdEditOPD.DataSource = dt;
        grdEditOPD.DataBind();
    }

    private void bindSubCategoryIPD()
    {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append("SELECT  sc.DisplayName,sc.SubCategoryID,con.ConfigID FROM f_subcategorymaster sc INNER JOIN f_categorymaster ca ON sc.CategoryID=ca.CategoryID");
        sb.Append(" INNER JOIN f_configrelation con ON ca.CategoryID=con.CategoryID WHERE sc.Active=1 GROUP BY sc.DisplayName");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        grdEditIPD.DataSource = dt;
        grdEditIPD.DataBind();
    }

    
    private void copyFrm()
    {
       // string cpyFrm = "SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE PanelID=" + ddlPanel.SelectedItem.Value + "";
        string cpyFrm = "SELECT rs.ScheduleChargeID,rs.NAME FROM  f_rate_schedulecharges rs LEFT JOIN f_ratelist rt  ON rt.ScheduleChargeID=rs.ScheduleChargeID  WHERE rt.PanelID=" + ddlPanel.SelectedItem.Value + " AND rt.IsCurrent=1 AND rt.CentreID=" + ddlCentreCopyFrom.SelectedValue + " GROUP BY rt.ScheduleChargeID ";
        DataTable dtFrm = StockReports.GetDataTable(cpyFrm);
         if (dtFrm.Rows.Count > 0)
        {
        ddlCpyFrm.DataSource = dtFrm;
        ddlCpyFrm.DataTextField = dtFrm.Columns["NAME"].ToString();
        ddlCpyFrm.DataValueField = dtFrm.Columns["ScheduleChargeID"].ToString();
        ddlCpyFrm.DataBind();
        }
         else
         {
             ddlCpyFrm.Items.Clear();
         }
    }

    private void copyFrmIPD()
    {
       // string cpyFrm = "SELECT NAME,PanelID FROM f_rate_schedulecharges WHERE ScheduleChargeID IN (SELECT DISTINCT ScheduleChargeID FROM f_ratelist_ipd WHERE Rate<>0)";
        string cpyFrm = "SELECT rs.ScheduleChargeID PanelID,rs.NAME FROM  f_rate_schedulecharges rs inner JOIN f_ratelist_ipd rt  ON rt.ScheduleChargeID=rs.ScheduleChargeID  WHERE rt.PanelID=" + ddlPanel.SelectedItem.Value + " AND rt.IsCurrent=1 AND rt.CentreID=" + ddlCentreCopyFrom.SelectedValue + " GROUP BY rt.ScheduleChargeID ";

        DataTable dtFrm = StockReports.GetDataTable(cpyFrm);
        if (dtFrm.Rows.Count > 0)
        {
            ddlCpyFrm.DataSource = dtFrm;
            ddlCpyFrm.DataTextField = dtFrm.Columns["NAME"].ToString();
            ddlCpyFrm.DataValueField = dtFrm.Columns["PanelID"].ToString();
            ddlCpyFrm.DataBind();
        }
        else
        {
            ddlCpyFrm.Items.Clear();
        }
    }

    private void CopyTo()
    {
        string cpyto = "SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE ScheduleChargeID NOT IN (SELECT DISTINCT ScheduleChargeID FROM f_ratelist WHERE Rate<>0)";

        DataTable dtTo = StockReports.GetDataTable(cpyto);
        ddlCpyTo.DataSource = dtTo;
        ddlCpyTo.DataTextField = dtTo.Columns["name"].ToString();
        ddlCpyTo.DataValueField = dtTo.Columns["ScheduleChargeID"].ToString();
        ddlCpyTo.DataBind();
    }

    private void CopyToIPD()
    {
        string cpyto = "SELECT NAME,ScheduleChargeID FROM f_rate_schedulecharges WHERE ScheduleChargeID NOT IN (SELECT DISTINCT ScheduleChargeID FROM f_ratelist_ipd WHERE Rate<>0)";

        DataTable dtTo = StockReports.GetDataTable(cpyto);
        ddlCpyTo.DataSource = dtTo;
        ddlCpyTo.DataTextField = dtTo.Columns["name"].ToString();
        ddlCpyTo.DataValueField = dtTo.Columns["ScheduleChargeID"].ToString();
        ddlCpyTo.DataBind();
    }

    private void Hide()
    {
        lblPanel.Visible = false;
        ddlPanel.Visible = false;
        LblCpyFrm.Visible = false;
        ddlCpyFrm.Visible = false;
        LblCpyTo.Visible = false;
        ddlCpyTo.Visible = false;
        lblCentreCopyto.Visible = false;
        lblCopyCentreFrom.Visible = false;
        ddlCentreCopyFrom.Visible = false;
        ddlCentreCopyto.Visible = false;
    }

    private void saverate()
    {
        foreach (GridViewRow gr in grdEditIPD.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSelectOne")).Checked == true)
            {
            }
        }
    }

    private void show()
    {
        lblPanel.Visible = true;
        ddlPanel.Visible = true;
        LblCpyFrm.Visible = true;
        ddlCpyFrm.Visible = true;
        LblCpyTo.Visible = true;
        ddlCpyTo.Visible = true;
        lblCentreCopyto.Visible = true;
        lblCopyCentreFrom.Visible = true;
        ddlCentreCopyFrom.Visible = true;
        ddlCentreCopyto.Visible = true;
    }

    private void BindFromCentreOPD()
    {
        string str = "SELECT cm.CentreID,cm.CentreName FROM  f_ratelist rt INNER JOIN center_master cm ON rt.CentreID=cm.CentreID WHERE rt.PanelID='"+ddlPanel.SelectedValue+"' AND rt.IsCurrent=1 GROUP BY rt.CentreID ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        if (dtCentre.Rows.Count > 0)
        {
            ddlCentreCopyFrom.DataSource = dtCentre;
            ddlCentreCopyFrom.DataTextField = "CentreName";
            ddlCentreCopyFrom.DataValueField = "CentreID";
            ddlCentreCopyFrom.DataBind();
            copyFrm();
        }
        else
        {
            ddlCentreCopyFrom.Items.Clear();
        }
    }
    private void BindToCentreOPD()
    {
        string str = "SELECT cm.CentreID,cm.CentreName FROM f_center_panel cp INNER JOIN center_master cm ON cp.CentreID=cm.CentreID INNER JOIN f_panel_master pnl ON pnl.PanelID = cp.PanelID AND pnl.ReferenceCodeOPD = pnl.PanelID LEFT JOIN f_ratelist rt ON rt.CentreID = cp.CentreID AND rt.PanelID = cp.PanelID AND rt.IsCurrent=1 WHERE pnl.PanelID='" + ddlPanel.SelectedValue.ToString() + "'   and cp.isactive=1 group by cp.CentreID ";
        DataTable dtCentre = StockReports.GetDataTable(str);
         if (dtCentre.Rows.Count > 0)
        {
        ddlCentreCopyto.DataSource = dtCentre;
        ddlCentreCopyto.DataTextField = "CentreName";
        ddlCentreCopyto.DataValueField = "CentreID";
        ddlCentreCopyto.DataBind();
        CopyTo();
        }
         else
         {
             ddlCentreCopyto.Items.Clear();
         }
    }

    private void BindFromCentreIPD()
    {
        string str = "SELECT cm.CentreID,cm.CentreName FROM  f_ratelist_ipd rt INNER JOIN center_master cm ON rt.CentreID=cm.CentreID WHERE rt.PanelID='" + ddlPanel.SelectedValue + "' AND rt.IsCurrent=1 GROUP BY rt.CentreID ";
         
        DataTable dtCentre = StockReports.GetDataTable(str);
        if (dtCentre.Rows.Count > 0)
        {
        ddlCentreCopyFrom.DataSource = dtCentre;
        ddlCentreCopyFrom.DataTextField = "CentreName";
        ddlCentreCopyFrom.DataValueField = "CentreID";
        ddlCentreCopyFrom.DataBind();
        copyFrmIPD();
        }
        else
        {
            ddlCentreCopyFrom.Items.Clear();
        }
    }
    private void BindToCentreIPD()
    {
        string str = "SELECT cm.CentreID,cm.CentreName FROM f_center_panel cp INNER JOIN center_master cm ON cp.CentreID=cm.CentreID INNER JOIN f_panel_master pnl ON pnl.PanelID = cp.PanelID AND pnl.ReferenceCode = pnl.PanelID LEFT JOIN f_ratelist_ipd rt ON rt.CentreID = cp.CentreID AND rt.PanelID = cp.PanelID AND rt.IsCurrent=1 WHERE rt.RateListID IS NULL AND pnl.PanelID='" + ddlPanel.SelectedValue.ToString() + "' ";
        DataTable dtCentre = StockReports.GetDataTable(str);
        if (dtCentre.Rows.Count > 0)
        {
            ddlCentreCopyto.DataSource = dtCentre;
            ddlCentreCopyto.DataTextField = "CentreName";
            ddlCentreCopyto.DataValueField = "CentreID";
            ddlCentreCopyto.DataBind();
            CopyToIPD();
        }
        else
        {
            ddlCentreCopyto.Items.Clear();
        }
    }
}