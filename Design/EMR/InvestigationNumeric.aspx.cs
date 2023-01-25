using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EMR_InvestigationNumeric : System.Web.UI.Page
    {
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblTID.Text = Request.QueryString["TransactionID"].ToString();
            }
        }

    public DataTable getPatientInvestigationNimeric(string TransactionID)
        {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT CONCAT(im.Name) Investigation,CONCAT(DATE_FORMAT(t.Result_Date,'%d-%m-%y'),' ',  ");
        sb.Append(" TIME_FORMAT(t.Result_Time,'%I:%i%p'))DATE,IFNULL(t.Value,'')Value ,t.ReadingFormat,t.MinValue,t.MaxValue,im.Investigation_Id,ParentID,LabObservationName ,t.Priorty,t.Labno,t.plitestID  FROM    ");
        sb.Append(" (	 ");
        sb.Append(" SELECT pli.LabInvestigationIPD_ID,pli.Investigation_Id,ploi.Result_Time,ploi.Result_Date,ploi.Value,  ");
        sb.Append("     ploi.MinValue,ploi.MaxValue,ploi.LabObservationName,ParentID,ploi.LabObservation_ID,Child_Flag, Priorty , REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI',''),'LISHHI','') AS LabNo,PLI.`Test_ID` AS plitestid,ploi.Test_ID,epi.TransactionID,ReadingFormat FROM patient_labinvestigation_opd  pli  ");
        sb.Append("     INNER JOIN (SELECT TransactionID,Test_ID FROM emr_patient_investigation WHERE TransactionID='" + TransactionID + "' AND IsPrint=1) epi   ");
        sb.Append("     ON epi.Test_ID = pli.Test_ID  ");
        sb.Append("     INNER JOIN patient_labobservation_ipd ploi ON ploi.Test_ID = pli.Test_ID    ");
        sb.Append("     INNER JOIN labobservation_master lm ON lm.LabObservation_ID = ploi.LabObservation_ID		 ");
        sb.Append("     WHERE pli.approved=1   ");
        sb.Append(" ");

        sb.Append(")t  ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=t.Investigation_Id    ");
        sb.Append(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID = im.Investigation_Id    ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id  ");
        sb.Append(" LEFT JOIN labobservation_investigation lai ON lai.Investigation_Id=t.Investigation_Id  AND lai.labObservation_ID=t.labObservation_ID ");
        sb.Append(" WHERE im.ReportType =1 ORDER BY otm.Name,im.Name,t.Result_Date,t.Result_Time,t.Priorty,t.Labno,t.plitestid  ");
       // sb.Append(" WHERE im.ReportType =1 ORDER BY otm.Name,im.Name,t.Result_Date,t.Result_Time   ");

        DataTable dtLabOb = StockReports.GetDataTable(sb.ToString());



        ///////////////////

        string Investigations = string.Empty;
        for (int i = 0; i < dtLabOb.Rows.Count; i++)
        {
            if (dtLabOb.Rows[i]["Investigation_ID"].ToString().Length > 2)
                Investigations = Investigations + "'" + dtLabOb.Rows[i]["Investigation_ID"].ToString() + "',";


            if (dtLabOb.Rows[i]["ParentID"].ToString() != "")
            {
                DataRow[] PrExist = dtLabOb.Select("LabObservation_ID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "'");

                if (PrExist.Length <= 0)
                {
                    DataRow row = dtLabOb.NewRow();
                    row.ItemArray = dtLabOb.Rows[i].ItemArray;
                    DataTable dtlb = StockReports.GetDataTable("SELECT lm.*,li.Priorty FROM labobservation_master lm INNER JOIN labobservation_investigation li ON lm.LabObservation_ID = li.labObservation_ID WHERE li.labObservation_ID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "' limit 1");
                    // row["LabObservation_ID"] = dtlb.Rows[0]["LabObservation_ID"].ToString();
                    row["LabObservationName"] = dtlb.Rows[0]["NAME"].ToString();
                    // row["Child_Flag"] = dtlb.Rows[0]["Child_Flag"].ToString();
                    //  row["ParentID"] = dtlb.Rows[0]["ParentID"].ToString();
                    //  row["InvPriorty"] = dtlb.Rows[0]["Priorty"].ToString();
                    //   row["Priorty"] = dtlb.Rows[0]["Priorty"].ToString();
                    row["VALUE"] = "";
                    row["MinValue"] = "";
                    row["MaxValue"] = "";
                    row["DATE"] = "";
                    //row["IsParent"] = "Y";
                    //   row["Investigation_ID"] = dtLabOb.Rows[i]["Investigation_ID"].ToString();
                    //   row["Test_ID"] = dtLabOb.Rows[i]["Test_ID"].ToString();
                    //   row["TransactionID"] = dtLabOb.Rows[i]["TransactionID"].ToString();

                    //DataRow[] PrChild = dtLabOb.Select("ParentID='" + dtLabOb.Rows[i]["ParentID"].ToString() + "'");
                    //if (PrChild.Length > 0)
                    //{
                    //    foreach (DataRow dr1 in PrChild)
                    //    {
                    //        dr1["InvPriorty"] = dtlb.Rows[0]["Priorty"].ToString();
                    //    }
                    //}

                    dtLabOb.Rows.InsertAt(row, i);
                    dtLabOb.AcceptChanges();

                }
            }
        }
        DataView view = new DataView(dtLabOb);
        DataTable dt = view.ToTable("Selected", false, "Investigation", "DATE", "Value", "ReadingFormat", "MinValue", "MaxValue", "LabObservationName");

        return dt;


    }

    public void getDataTableNumeric(string TransactionID)
    {

        DataTable dt = getPatientInvestigationNimeric(TransactionID);
        DataRow row;
        DataTable dtbl = new DataTable();
        DataColumn col1 = new DataColumn("Name");
        dtbl.Columns.Add(col1);

        DataColumn col2 = new DataColumn("Value");
        dtbl.Columns.Add(col2);

        DataColumn col3 = new DataColumn("Reading Format");
        dtbl.Columns.Add(col3);

        DataColumn col4 = new DataColumn("Min Value");
        dtbl.Columns.Add(col4);

        DataColumn col5 = new DataColumn("Max Value");
        dtbl.Columns.Add(col5);
        DataColumn col6 = new DataColumn("DATE");
        dtbl.Columns.Add(col6);

        DataTable dt1 = dt.DefaultView.ToTable(true, "Investigation");
        for (int i = 0; i < dt1.Rows.Count; i++)
        {
            row = dtbl.NewRow();
            row["Name"] = dt1.Rows[i][0].ToString();
            dtbl.Rows.Add(row);

            DataView dv = new DataView(dt);
            dv.RowFilter = "Investigation='" + dt1.Rows[i][0].ToString() + "'";

            DataTable dt2 = dv.ToTable();

            for (int j = 0; j < dt2.Rows.Count; j++)
            {
                row = dtbl.NewRow();
                row["Name"] = dt2.Rows[j]["LabObservationName"].ToString();
                row["Value"] = dt2.Rows[j]["VALUE"].ToString();
                row["Reading Format"] = dt2.Rows[j]["ReadingFormat"].ToString();
                row["Min Value"] = dt2.Rows[j]["MinValue"].ToString();
                row["Max Value"] = dt2.Rows[j]["MaxValue"].ToString();
                row["DATE"] = dt2.Rows[j]["DATE"].ToString();
                dtbl.Rows.Add(row);
            }
        }
        grdNumeric.DataSource = dtbl;
        grdNumeric.DataBind();

        ExportGridToExcel(grdNumeric, "Investigation Text");
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);



    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (rdoType.SelectedItem.Value == "1")
            getDataTableNumeric(lblTID.Text);
        else
            getPatientInvestigationText(lblTID.Text);
    }


    public void getPatientInvestigationText(string TID)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" Select im.Name Investigation,date_format(t.Date,'%d-%b-%Y')Date, ");
        sb.Append(" t.LabInves_Description Result from   ");
        sb.Append(" (Select pli.Date,pli.Time,pli.LabInvestigationIPD_ID,pli.Investigation_Id,epi.Remarks,pli.LabInves_Description from  ");
        sb.Append("     patient_labinvestigation_opd  pli inner join ( ");
        sb.Append("     select Remarks,Test_ID from emr_patient_investigation where TransactionID='" + TID + "' and IsPrint=1) epi ");
        sb.Append("     on epi.Test_ID = pli.Test_ID  Where pli.approved=1");
        sb.Append(" ) t ");
        sb.Append(" inner join investigation_master im on im.Investigation_Id=t.Investigation_Id ");
        sb.Append(" inner join investigation_observationtype iot on iot.Investigation_ID = im.Investigation_Id ");
        sb.Append(" inner join observationtype_master otm on otm.ObservationType_ID=iot.ObservationType_Id ");
        sb.Append(" where im.ReportType !=1 order by otm.Name,im.Name,t.Date,t.Time ");




        DataTable dtText = StockReports.GetDataTable(sb.ToString());

        grdInvText.DataSource = dtText;
        grdInvText.DataBind();
        ExportGridToExcel(grdInvText, "Investigation Text");
    }

    protected void grdInvText_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string decodedText = HttpUtility.HtmlDecode(e.Row.Cells[2].Text);
            e.Row.Cells[2].Text = decodedText;
        }
    }
   

    
    public void ExportGridToExcel(GridView grdGridView, string fileName)
    {
        Response.Clear();
        Response.AddHeader("content-disposition", string.Format
            ("attachment;filename={0}.xls", fileName));
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";
        StringWriter stringWrite = new StringWriter();
        HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
        grdGridView.RenderControl(htmlWrite);
        Response.Write(stringWrite.ToString());
        Response.End();
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
           server control at run time. */
    }
}
