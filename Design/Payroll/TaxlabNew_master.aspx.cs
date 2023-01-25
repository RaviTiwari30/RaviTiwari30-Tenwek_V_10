using System;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Payroll_TaxlabNew_master : System.Web.UI.Page
{
    protected void BindDetail()
    {
        string sql = "";
        sql = "select * from  pay_taxslab_masternew where year='" + ddlyear.SelectedItem.Text + "'";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt != null && dt.Rows.Count > 0)
        {
            grd.DataSource = dt;
            grd.DataBind();
            ViewState["dtfrm"] = dt;
            for (int i = 0; i < grd.Rows.Count; i++)
            {
                Label lbl = ((Label)grd.Rows[i].FindControl("lblyear"));
                lbl.Text = dt.Rows[i]["Year"].ToString();
                TextBox box1 = ((TextBox)grd.Rows[i].FindControl("txtIncomefrom"));
                box1.Text = dt.Rows[i]["Incomefrom"].ToString();
                TextBox box2 = ((TextBox)grd.Rows[i].FindControl("txtIncometo"));
                box2.Text = dt.Rows[i]["Incometo"].ToString();
                TextBox box3 = ((TextBox)grd.Rows[i].FindControl("txtPercentage"));
                box3.Text = dt.Rows[i]["taxper"].ToString();
                TextBox box4 = ((TextBox)grd.Rows[i].FindControl("txtRate"));
                box4.Text = dt.Rows[i]["Rate"].ToString();
            }
            int count = int.Parse(grd.Rows.Count.ToString());
            for (int k = 0; k < count - 1; k++)
            {
                TextBox tb = (TextBox)grd.Rows[k].Cells[1].FindControl("txtIncomefrom");
                tb.Enabled = false;
                TextBox box2 = ((TextBox)grd.Rows[k].FindControl("txtIncometo"));
                box2.ReadOnly = true;
                TextBox box3 = ((TextBox)grd.Rows[k].FindControl("txtPercentage"));
                box3.ReadOnly = true;
                TextBox box4 = ((TextBox)grd.Rows[k].FindControl("txtRate"));
                box4.ReadOnly = true;
            }
            btnSave.Enabled = true;
        }
        else
        {
            if (ddlyear.SelectedItem.Text == "Select")
            {
                btnSave.Enabled = false;
            }
            else
            {
                btnSave.Enabled = true;
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string strQuery = "";
            strQuery = "delete from pay_taxslab_masternew where year='" + ddlyear.SelectedItem.Text + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
            for (int i = 0; i < grd.Rows.Count; i++)
            {
                string label = ((Label)grd.Rows[i].FindControl("lblyear")).Text;
                string textbox1 = ((TextBox)grd.Rows[i].FindControl("txtIncomefrom")).Text;
                string textbox2 = ((TextBox)grd.Rows[i].FindControl("txtIncometo")).Text;
                string textbox3 = ((TextBox)grd.Rows[i].FindControl("txtPercentage")).Text;
                string textbox4 = ((TextBox)grd.Rows[i].FindControl("txtRate")).Text;
                int isactive = 1;
                if (textbox2.ToString() == "")
                {
                    lblmsg.Text = "Please Enter Income To";
                    return;
                }
                if (textbox3.ToString() == "")
                {
                    lblmsg.Text = "Please Enter Tax";
                    return;
                }
                if (textbox4.ToString() == "")
                {
                    lblmsg.Text = "Please Enter Rate";
                    return;
                }
                strQuery = "INSERT INTO pay_taxslab_masternew(YEAR,IncomeFrom,IncomeTo,taxper,rate,IsActive,CreatedBy,CreatedDate) VALUES('" + label + "','" + textbox1 + "','" + textbox2 + "','" + textbox3 + "','" + textbox4 + "','" + isactive + "','" + ViewState["ID"] + "','" + DateTime.Now.ToString("yyyy-MM-dd") + "');";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strQuery);
            }
            lblmsg.Text = "Record Saved Successfully";
            Tranx.Commit();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void ddlyear_SelectedIndexChanged(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        if (ddlyear.SelectedItem.Text != "Select")
        {
            SetInitialRow();
            BindDetail();
        }
        else
        {
            btnSave.Enabled = false;
            grd.DataSource = null;
            grd.DataBind();
        }
    }

    protected void grd_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Add")
        {
            lblmsg.Text = "";
            int rowIndex = 0;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                DataTable dtCurrentTable = (DataTable)ViewState["dtfrm"];

                DataRow drCurrentRow = null;
                if (dtCurrentTable.Rows.Count > 0)
                {
                    //Store the current data to ViewState
                    for (int i = 1; i <= dtCurrentTable.Rows.Count; i++)
                    {
                        TextBox box1 = (TextBox)grd.Rows[rowIndex].Cells[1].FindControl("txtIncomefrom");
                        TextBox box2 = (TextBox)grd.Rows[rowIndex].Cells[2].FindControl("txtIncometo");
                        TextBox box3 = (TextBox)grd.Rows[rowIndex].Cells[3].FindControl("txtPercentage");
                        TextBox box4 = (TextBox)grd.Rows[rowIndex].Cells[3].FindControl("txtRate");
                        box1.ReadOnly = true;
                        drCurrentRow = dtCurrentTable.NewRow();
                        drCurrentRow["Id"] = i + 1;
                        if (box1.Text == " ")
                        {
                            lblmsg.Text = "Please Enter Income From";
                            return;
                        }
                        else
                        {
                            dtCurrentTable.Rows[i - 1]["Incomefrom"] = box1.Text;
                        }
                        if (box2.Text == "")
                        {
                            lblmsg.Text = "Please Enter Income To";
                            return;
                        }
                        else
                        {
                            dtCurrentTable.Rows[i - 1]["Incometo"] = box2.Text;
                        }
                        if (box3.Text == "")
                        {
                            lblmsg.Text = "Please Enter Tax";
                            return;
                        }
                        else
                        {
                            dtCurrentTable.Rows[i - 1]["Taxper"] = box3.Text;
                        }
                        if (box4.Text == "")
                        {
                            lblmsg.Text = "Please Enter Rate";
                            return;
                        }
                        else
                        {
                            dtCurrentTable.Rows[i - 1]["Rate"] = box4.Text;
                        }
                        if (Util.GetDecimal(box2.Text) > Util.GetDecimal(box1.Text))
                        {
                            rowIndex++;
                        }
                        else
                        {
                            lblmsg.Text = "Income To Amount Cannot Be Smaller Or Equals Than Income from Amount";
                            return;
                        }
                    }

                    dtCurrentTable.Rows.Add(drCurrentRow);
                    ViewState["dtfrm"] = dtCurrentTable;

                    grd.DataSource = dtCurrentTable;
                    grd.DataBind();
                }

                //Rebind the Grid with the current data
                else
                {
                }

                //Set Previous Data on Postbacks
                SetPreviousData();
                int count = int.Parse(grd.Rows.Count.ToString());
                for (int k = 0; k < count - 1; k++)
                {
                    TextBox tb = (TextBox)grd.Rows[k].Cells[1].FindControl("txtIncomefrom");
                    tb.Enabled = false;
                }
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
        }
        if (e.CommandName == "reject")
        {
            int args = Util.GetInt(e.CommandArgument.ToString());
            DataTable dt = (DataTable)ViewState["dtfrm"];
            dt.Rows[args - 1].Delete();
            dt.AcceptChanges();
            grd.DataSource = dt;
            grd.DataBind();
            SetPreviousData();
            int count = int.Parse(grd.Rows.Count.ToString());
            if (count > 1)
            {
                for (int k = 0; k < count - 1; k++)
                {
                    TextBox tb = (TextBox)grd.Rows[k].Cells[1].FindControl("txtIncomefrom");
                    tb.Enabled = false;
                }
            }
            else if (count == 1)
            {
                TextBox tb = (TextBox)grd.Rows[0].Cells[1].FindControl("txtIncomefrom");
                tb.Enabled = true;
            }
            else
            {
                btnSave.Enabled = false;
            }
            ViewState["dtfrm"] = dt;
        }
    }

    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            TextBox msgtxtBox1 = (TextBox)e.Row.FindControl("txtIncomefrom");
            msgtxtBox1.ReadOnly = true;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            BindDetail();
        }
    }

    private void SetInitialRow()
    {
        DataTable dt = new DataTable();
        DataRow dr = null;
        dt.Columns.Add(new DataColumn("ID", typeof(string)));

        dt.Columns.Add(new DataColumn("Year", typeof(int)));
        dt.Columns.Add(new DataColumn("Incomefrom", typeof(string)));
        dt.Columns.Add(new DataColumn("Incometo", typeof(string)));
        dt.Columns.Add(new DataColumn("taxper", typeof(string)));
        dt.Columns.Add(new DataColumn("Rate", typeof(string)));
        dr = dt.NewRow();
        dr["ID"] = 1;

        dr["Year"] = ddlyear.SelectedItem.Text;
        dr["Incomefrom"] = "0";
        dr["Incometo"] = string.Empty;
        dr["taxper"] = string.Empty;
        dr["Rate"] = string.Empty;
        dt.Rows.Add(dr);

        ViewState["dtfrm"] = dt;

        grd.DataSource = dt;
        grd.DataBind();
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                Label lbl = ((Label)grd.Rows[i].FindControl("lblyear"));
                lbl.Text = ddlyear.SelectedItem.Text;
            }
            TextBox box1 = ((TextBox)grd.Rows[0].FindControl("txtIncomefrom"));
            box1.Text = "0.00";
        }
    }

    private void SetPreviousData()
    {
        decimal ab = 0;
        decimal abc = 0;
        int rowIndex = 0;
        if (ViewState["dtfrm"] != null)
        {
            DataTable dt = (DataTable)ViewState["dtfrm"];
            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    if (rowIndex == 0)
                    {
                        Label lbl = (Label)grd.Rows[rowIndex].Cells[1].FindControl("lblyear");
                        TextBox box1 = (TextBox)grd.Rows[rowIndex].Cells[1].FindControl("txtIncomefrom");
                        TextBox box2 = (TextBox)grd.Rows[rowIndex].Cells[2].FindControl("txtIncometo");
                        TextBox box3 = (TextBox)grd.Rows[rowIndex].Cells[3].FindControl("txtPercentage");
                        TextBox box4 = (TextBox)grd.Rows[rowIndex].Cells[3].FindControl("txtRate");
                        lbl.Text = ddlyear.SelectedItem.Text;
                        box1.Text = dt.Rows[i]["Incomefrom"].ToString();
                        box2.Text = dt.Rows[i]["Incometo"].ToString();
                        box3.Text = dt.Rows[i]["taxper"].ToString();
                        box4.Text = dt.Rows[i]["Rate"].ToString();
                        ab = Util.GetDecimal(box2.Text);
                        box1.Enabled = false;
                    }
                    else
                    {
                        Label lbl = (Label)grd.Rows[rowIndex].Cells[1].FindControl("lblyear");
                        TextBox box1 = (TextBox)grd.Rows[rowIndex].Cells[1].FindControl("txtIncomefrom");
                        TextBox box2 = (TextBox)grd.Rows[rowIndex].Cells[2].FindControl("txtIncometo");
                        TextBox box3 = (TextBox)grd.Rows[rowIndex].Cells[3].FindControl("txtPercentage");
                        TextBox box4 = (TextBox)grd.Rows[rowIndex].Cells[3].FindControl("txtRate");
                        lbl.Text = ddlyear.SelectedItem.Text;
                        box1.Text = Util.GetString(abc);

                        box2.Text = dt.Rows[i]["Incometo"].ToString();
                        box3.Text = dt.Rows[i]["taxper"].ToString();
                        box4.Text = dt.Rows[i]["Rate"].ToString();
                        ab = Util.GetDecimal(box2.Text);
                    }

                    rowIndex++;
                    abc = ab;
                    if (rowIndex == 0)
                    {
                    }
                    else
                    {
                        abc = abc + 1;
                    }
                    int count = int.Parse(grd.Rows.Count.ToString());
                    for (int k = 0; k < count - 1; k++)
                    {
                        TextBox tb = (TextBox)grd.Rows[k].Cells[1].FindControl("txtIncomefrom");
                        tb.Enabled = false;
                        TextBox box2 = ((TextBox)grd.Rows[k].FindControl("txtIncometo"));
                        box2.ReadOnly = true;
                        TextBox box3 = ((TextBox)grd.Rows[k].FindControl("txtPercentage"));
                        box3.ReadOnly = true;
                        TextBox box4 = ((TextBox)grd.Rows[k].FindControl("txtRate"));
                        box4.ReadOnly = true;
                    }
                }
            }
        }
    }
}