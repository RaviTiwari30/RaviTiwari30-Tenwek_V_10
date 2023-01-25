using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Purchase_SetPRQuantity : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindStoreDept();
        }
        txtCurrentQtyRel.Attributes.Add("readOnly", "readOnly");
    }

    private void bindStoreDept()
        {
        DataTable storeDept = LoadCacheQuery.bindStoreDepartment();
        storeDept = storeDept.AsEnumerable().Where(r => r.Field<int>("IsStore") == 1 || r.Field<int>("IsGeneral") == 1 || r.Field<int>("IsMedical") == 1 || r.Field<int>("IsIndent") == 1).AsDataView().ToTable();
        if (storeDept.Rows.Count > 0)
            {
            chklDept.DataSource = storeDept;
            chklDept.DataTextField = "ledgerName";
            chklDept.DataValueField = "ledgerNumber";
            chklDept.DataBind();

            }
        }
    protected void grdPR_RowCreated(object sender, GridViewRowEventArgs e)
        {
        int k = 0;
        int count = (int)ViewState["HeaderCount"];
        if (e.Row.RowType == DataControlRowType.Header)
            {
            DataTable dt = bindStoreHeader();
            ViewState["StoreHeader"] = dt;
            //        DataTable dt = bindHeader();

            //        ViewState["Header"] = dt;
            foreach (DataColumn column in dt.Columns)
                {
                // Label lbl = new Label();
                TableCell headerCell = new TableCell();
                //   lbl.Text = dt.Rows[i]["ledgerName"].ToString();
                //   lbl.ID = dt.Rows[i]["ledgerNumber"].ToString();

                headerCell.Text = column.ColumnName;

                headerCell.Font.Bold = true;
                // headerCell.Controls.Add(lbl);
                e.Row.Cells.Add(headerCell);
                }
            }
        if (e.Row.RowType == DataControlRowType.DataRow)
            {
            k++;
            DataTable dt = (DataTable)ViewState["StoreHeader"];
            foreach (DataColumn column in dt.Columns)
                {
                TextBox txt = new TextBox();
                TableCell dataCell = new TableCell();
                txt.EnableViewState = true;
                txt.ID = "txt_" + (Convert.ToInt32(k + 1)).ToString();
                dataCell.Controls.Add(txt);
                e.Row.Cells.Add(dataCell);


                }
            }
        }
    protected void grdPR_RowDataBound(object sender, GridViewRowEventArgs e)
        {
        if (e.Row.RowType == DataControlRowType.Header)
            {
            //  e.Row.Cells[2].Visible = false;
            //   e.Row.Cells[3].Visible = false;
            e.Row.CssClass = "GridViewHeaderStyle";
            }
        // int i = 0;
        if (e.Row.RowType == DataControlRowType.DataRow)
            {

            //var colCount = e.Row.Cells.Count;
            //TextBox txt = new TextBox();
            //TableCell dataCell = new TableCell();
            //txt.EnableViewState = true;
            //txt.ID = "txt_" + (Convert.ToInt32(i + 1)).ToString();
            //dataCell.Controls.Add(txt);
            //e.Row.Cells.Add(dataCell);
            //i++;

            //  DataRowView row = (DataRowView)e.Row.DataItem;
            //  e.Row.Cells[2].Visible = false;
            //  e.Row.Cells[3].Visible = false;

            }
        }

    private DataTable bindStoreHeader()
        {
        DataTable inputTable = LoadCacheQuery.bindStoreDepartment();
        DataTable dtSoreDept = new DataTable();
        foreach (DataRow dr in inputTable.Rows)
            {
            string StoreName = Util.GetString(dr["ledgerName"]);

            dtSoreDept.Columns.Add(StoreName).DataType = typeof(string);
            dtSoreDept.Columns.Add(Util.GetString(dr["ledgerNumber"])).DataType = typeof(string);
            string deptStock = StoreName + "_StockDept";
            string currentQty = StoreName + "_currentQty";
            string Min = StoreName + "_Min";
            string Max = StoreName + "_Max";
            dtSoreDept.Columns.Add(deptStock).DataType = typeof(string);
            dtSoreDept.Columns.Add(currentQty).DataType = typeof(string);
            dtSoreDept.Columns.Add(Min).DataType = typeof(string);
            dtSoreDept.Columns.Add(Max).DataType = typeof(string);
            }
        return dtSoreDept;
        }

    private DataTable bindHeader()
        {
        // DataTable inputTable = LoadCacheQuery.bindStoreDepartment();
        DataTable dtSoreDept = new DataTable();
        // string item = "";
        // item = "SELECT TypeName ItemName,ItemID FROM f_itemmaster im   INNER JOIN f_subcategorymaster SM ON IM.SubCategoryID = SM.SubCategoryID INNER JOIN f_configrelation CR ON SM.CategoryID = CR.CategoryID WHERE CR.ConfigID = '" + rdoStoretype.SelectedValue + "' AND im.IsActive=1 ";
        // DataTable dtItem = StockReports.GetDataTable(item);
        // if (inputTable.Rows.Count > 0)
        //     {
        dtSoreDept.Columns.Add("ItemName").DataType = typeof(string);
        dtSoreDept.Columns.Add("ItemID").DataType = typeof(string);
        //foreach (DataRow dr in inputTable.Rows)
        //    {
        //     string StoreName = Util.GetString(inputTable.Rows[0]["ledgerName"]);

        //         dtSoreDept.Columns.Add(StoreName).DataType = typeof(string);
        //         dtSoreDept.Columns.Add(Util.GetString(inputTable.Rows[0]["ledgerNumber"])).DataType = typeof(string);
        //         string deptStock = StoreName + "_StockDept";
        //         string currentQty = StoreName + "_currentQty";
        //         string Min = StoreName + "_Min";
        //          string Max = StoreName + "_Max";
        //          dtSoreDept.Columns.Add(deptStock).DataType = typeof(string);
        //          dtSoreDept.Columns.Add(currentQty).DataType = typeof(string);
        //          dtSoreDept.Columns.Add(Min).DataType = typeof(string);
        //           dtSoreDept.Columns.Add(Max).DataType = typeof(string);



        DataRow drnew = dtSoreDept.NewRow();

        drnew["ItemName"] = Util.GetString(Request.Form[txtItemName.UniqueID]);

        drnew["ItemID"] = Util.GetString(Request.Form[hfItemId.UniqueID]);

        dtSoreDept.Rows.Add(drnew);
        //   }




        // }

        return dtSoreDept;
        }
    protected void btnAdd_Click(object sender, EventArgs e)
        {
        DataTable dtItem = bindHeader();
        if (dtItem.Rows.Count > 0)
            {
            ViewState["HeaderCount"] = dtItem.Rows.Count;
            grdPR.DataSource = dtItem;
            grdPR.DataBind();
            }
        }
    protected void btnSave_Click(object sender, EventArgs e)
        {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
            {
            string Storetype = "";
            if (rdoStoretype.SelectedValue == "11")
                Storetype = "STO00001";
            else
                Storetype = "STO00002";
            foreach (ListItem li in chklDept.Items)
                {
                if (li.Selected == true)
                    {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("  UPDATE f_setPurchaseRequestQuantity SET IsActive=0 WHERE  ItemID='" + Util.GetString(Request.Form[hfItemId.UniqueID]) + "' AND DeptLedgerNo='" + li.Value + "' ");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                    sb.Clear();
                
                    sb.Append(" INSERT INTO f_setPurchaseRequestQuantity(StoreType,ItemName,ItemID,LastMonthConsumption,DepartmentStock,CurrentQuantity,Minimum,Maximum,DeptLedgerNo,CreatedBy)");
                    sb.Append(" VALUES('" + Storetype + "','" + Util.GetString(Request.Form[txtItemName.UniqueID]) + "','" + Util.GetString(Request.Form[hfItemId.UniqueID]) + "','" + txtLMcon.Text + "','" + txtDepStockQty.Text + "',");
                    sb.Append(" '" + txtCurrentQtyRel.Text + "','" + Util.GetDecimal( txtMin.Text) + "','" +  Util.GetDecimal(txtMax.Text) + "','" + li.Value + "','" + Session["ID"].ToString() + "' ");
                    sb.Append(" )");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                    }

                }
            Tranx.Commit();
            lblMsg.Text = "Record Saved Successfully";

            clear();
            }
        catch (Exception ex)
            {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error occurred, Please contact administrator";
            Tranx.Rollback();

            }
        finally
            {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            }
        }

    private void clear()
        {
        txtItemName.Text = "";
        txtLMcon.Text = "";
        txtMax.Text = "";
        txtCurrentQtyRel.Text = "";
        txtDepStockQty.Text = "";
        txtMin.Text = "";
        for (int i = 0; i <= chklDept.Items.Count-1; i++)
            {
            chklDept.Items[i].Selected = false;
            }
        }
    }