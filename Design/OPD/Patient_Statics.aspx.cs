using System;
using System.Data;
using System.Text;

public partial class Design_OPD_Patient_Statics : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["UserID"] = Session["ID"].ToString();
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        Search();
    }
    protected void Search()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT lt.Date,sm.Name,COUNT(*) CPatient FROM temp_for_date td LEFT OUTER JOIN f_ledgertransaction lt ON td.dt=lt.Date INNER JOIN appointment ap ON lt.LedgerTransactionNo=ap.LedgerTnxNo");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo=lt.LedgerTransactionNo");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=ltd.SubCategoryID");
        sb.Append(" WHERE ltd.TypeOfTnx='OPD-APPOINTMENT' AND lt.IsCancel=0");
        sb.Append(" AND DATE(lt.Date)>='" + Convert.ToDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "' AND DATE(lt.Date)<='" + Convert.ToDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" GROUP BY lt.Date,ltd.SubCategoryID");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdstats.DataSource = dt;
            grdstats.DataBind();
        }
        StringBuilder sb1 = new StringBuilder();

        sb1.Append("SELECT sm.Name FROM f_subcategorymaster sm  INNER JOIN f_configrelation cf ON sm.CategoryID=cf.CategoryID AND ConfigID=5");
          DataTable dt1 = StockReports.GetDataTable(sb1.ToString());
          if (dt != null && dt.Rows.Count > 0)
          {
              DataTable dt2 = new DataTable();
              dt2.Columns.Add("Date");
              for(int i=0; i<dt1.Rows.Count;i++)
              {
                  dt2.Columns.Add(new DataColumn(dt1.Rows[i]["name"].ToString(), typeof(int)));
                 
              }
              dt2.Columns.Add(("Total"),typeof(int));
              DateTime FromDate = Util.GetDateTime(txtfromDate.Text);
              DateTime ToDate = Util.GetDateTime(txtToDate.Text);
              DataRow row = dt2.NewRow();
              
              while (FromDate <= ToDate)
              {
                  
                  dt2.Rows.Add(FromDate.ToString("dd-MMM-yyyy"));
               
                  FromDate = FromDate.AddDays(1);
                  row["Date"] = FromDate.ToString("dd-MMM-yyyy");
                  //dt2.Rows.Add(row);
              }
              //set default value 0

              for (int i = 0; i < dt2.Rows.Count; i++)
              {
                  for(int j=1;j<dt2.Columns.Count;j++)
                  {
                      dt2.Rows[i][j] = "0";
                  }
              }

              for (int i = 0; i < dt2.Rows.Count; i++)
              {
                  int total = 0;
                  DataRow[] Drow = dt.Select("Date='" + Util.GetDateTime(dt2.Rows[i]["Date"]).ToString("yyyy-MM-dd") + "'");
                  for (int j = 0; j < Drow.Length; j++)
                  {
                      dt2.Rows[i][Drow[j]["Name"].ToString()] = Drow[j]["CPatient"].ToString();
                      total = total + Util.GetInt(Drow[j]["CPatient"].ToString());
                  }
                  dt2.Rows[i]["Total"] = total;
              }

              //sum
              DataRow SumRow = dt2.NewRow();
              SumRow[0] = "Total";
              for (int s = 1; s < dt2.Columns.Count; s++)
              {
                  SumRow[s] = dt2.Compute("sum([" + dt2.Columns[s].ColumnName + "])","").ToString();
              }
              dt2.Rows.Add(SumRow);
              grdstats.DataSource = dt2;
              grdstats.DataBind();
              grdstats.Rows[grdstats.Rows.Count - 1].Font.Bold = true;
          }
    }
}