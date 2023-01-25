using System;
using System.Data;
using CrystalDecisions.CrystalReports.Engine;
using System.Text;
public partial class Design_Mortuary_MortuaryBillReport : System.Web.UI.Page
{
    ReportDocument obj1 = new ReportDocument();
    DataSet ds = new DataSet();
    DataTable dtLedgerTnx = new DataTable();
    DataTable dtLedgerTnxDetails = new DataTable();
    DataTable dtPackage = new DataTable();
    DataTable dtPackageDetail = new DataTable();
    DataTable dtReceipt = new DataTable();    
    DataTable dtItemDetail = new DataTable();
    DataTable dtNetAmtWord = new DataTable();
    AllQuery AQ = new AllQuery();


    protected void Page_Load(object sender, EventArgs e)
    {

	
        if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "?access=" + Util.getHash());
        }
        else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
        {
            Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
        }



        string lang_code = GetGlobalResourceObject("Resource", "Lang_Code").ToString();
        int ReportType = Util.GetInt(Request.QueryString["ReportType"].ToString());
        //PrintReportDetails(ReportType);

        if (Session["dtBilled"] != null)
        {
            dtLedgerTnx = (DataTable)Session["dtBilled"];
        }

        if (Session["Table"] != null)
        {
            dtLedgerTnxDetails = (DataTable)Session["Table"];
        }

        if (Session["dtPackage"] != null)
        {
            dtPackage = (DataTable)Session["dtPackage"];
        }

        if (Session["dtPackageDetail"] != null)
        {
            dtPackageDetail = (DataTable)Session["dtPackageDetail"];
        }

        if (Session["dtNetAmtWord"] != null)
        {
            dtNetAmtWord = (DataTable)Session["dtNetAmtWord"];
        }        

		 if (Session["dtReceipt"] != null)
        {
            dtReceipt = (DataTable)Session["dtReceipt"];
        }


        if (ReportType == 2)
        {
            DetailedBill();
        }
        else if (ReportType == 1)
        {
            SummaryBill();
        }
        else if (ReportType == 3)
        {
            PackageBreakup();
        }
        else if(ReportType == 4)
        {
            SummaryBillProvisional();
        }
        
    }
    public void DetailedBill()
    {
        try
        {          
            DataTable dtVerLedgerTnxDetails = new DataTable();
            if (!dtLedgerTnxDetails.Columns.Contains("ShowSummary"))
            {
                dtLedgerTnxDetails.Columns.Add("ShowSummary");
            }
            dtVerLedgerTnxDetails = dtLedgerTnxDetails.Clone();
            DataTable dtNetAmtWord = new DataTable();
            if (Session["dtNetAmtWord"] != null)
            {
                dtNetAmtWord = ((DataTable)Session["dtNetAmtWord"]).Copy();
                if (dtNetAmtWord.Columns.Contains("PanelAppRemarks") == false) dtNetAmtWord.Columns.Add("PanelAppRemarks");
                dtNetAmtWord.Rows[0]["PanelAppRemarks"] = StockReports.ExecuteScalar("Select PanelAppRemarks from f_ipdAdjustment where Transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");
                if (dtNetAmtWord.Columns.Contains("PanelApprovedAmt") == false) dtNetAmtWord.Columns.Add("PanelApprovedAmt");
                dtNetAmtWord.Rows[0]["PanelApprovedAmt"] = StockReports.ExecuteScalar("Select IFNULL(PanelApprovedAmt,0)PanelApprovedAmt from f_ipdAdjustment where Transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");
                string NetAmount = dtNetAmtWord.Rows[0]["NetAmount"].ToString();
                if (NetAmount == "") NetAmount = "0";
                if (Util.GetFloat(NetAmount) < 0)
                {
                    NetAmount = NetAmount.Remove(0, 1);
                }
                NetAmount = Util.GetString((Util.GetDecimal(NetAmount)));
                dtNetAmtWord.Rows[0]["NetAmountWord"] = StockReports.ChangeNumericToWords(Util.GetString((Util.GetDecimal(dtNetAmtWord.Rows[0]["NetAmount"].ToString()))));
            }
            DataRow[] drLtnxDetails = dtLedgerTnxDetails.Select("IsVerified=1 and IsPackage =0");
            foreach (DataRow dr in drLtnxDetails)
            {
                if (dr["DisplayName"].ToString() == "")
                {
                    dr["DisplayName"] = "#";
                }                                
                if (dr["DisplayName"].ToString() == "CROSS CONSULTANCY" || dr["DisplayName"].ToString() == "Room Charges" || dr["DisplayName"].ToString() == "IPD CONSULTATION" || dr["DisplayName"].ToString() == "EQUIPMENT CHARGES" || dr["DisplayName"].ToString() == "INJECTION CHARGES" || dr["DisplayName"].ToString() == "Package" || dr["DisplayName"].ToString() == "Procedure Charges" || dr["DisplayName"].ToString() == "STENT CHARGES" || dr["DisplayName"].ToString() == "OTHER CHARGES" || dr["DisplayName"].ToString() == "Procedure Charges." || dr["DisplayName"].ToString() == "NURSING CARE CHARGES" || dr["DisplayName"].ToString() == "RMO CHARGES")
                {
                        if (dr["DisplayName"].ToString() == "IPD CONSULTATION" || dr["DisplayName"].ToString() == "CROSS CONSULTANCY")
                        {
                            dr["ItemName"] = "Dr. " + dr["ItemName"].ToString() + "  (" + dr["Specialization"].ToString() + ")" ;
                        }
                        dr["ShowSummary"] = 1;                  
                }
                else
                {
                    dr["ShowSummary"] = 0;
                }
                dtVerLedgerTnxDetails.ImportRow(dr);
            }        
            DataTable dtHeader = IPDBilling.getPatientHeaderForReport1(dtLedgerTnx.Rows[0]["Patient_id"].ToString(), dtLedgerTnx.Rows[0]["Transaction_ID"].ToString());         
            dtHeader.TableName = "Header";
            dtLedgerTnx.TableName = "LedgerTnx";
            dtVerLedgerTnxDetails.TableName = "LedgerTnxDetails";
            if (dtHeader != null && dtHeader.Rows.Count > 0)
            {
                if (dtHeader.Columns.Contains("DiscountOnBill") == false) dtHeader.Columns.Add("DiscountOnBill");
                if (dtHeader.Columns.Contains("UserName") == false) dtHeader.Columns.Add("UserName");
                if (dtHeader.Columns.Contains("LoginName") == false) dtHeader.Columns.Add("LoginName");

                AllQuery AQ = new AllQuery();
                DataTable dt = AQ.GetPatientAdjustmentDetails(dtLedgerTnx.Rows[0]["Transaction_ID"].ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataTable dtuser = AQ.GetUserinformation(dt.Rows[0]["UserID"].ToString().Trim());
                    string Username = "", LoginName = "";
                    if (dtuser != null && dtuser.Rows.Count > 0)
                    {
                        Username = dtuser.Rows[0]["UserName"].ToString();
                        LoginName = dtuser.Rows[0]["LoginName"].ToString();
                    }
                    else
                    {
                        Username = Session["LoginName"].ToString();
                        LoginName = Session["UserName"].ToString();
                    }
                    if (dt.Rows[0]["DiscountOnBill"].ToString().Trim() != "")
                    {
                        dtHeader.Rows[0]["DiscountOnBill"] = dt.Rows[0]["DiscountOnBill"].ToString().Trim();
                        dtHeader.Rows[0]["UserName"] = Username;
                        dtHeader.Rows[0]["LoginName"] = LoginName;
                    }
                    else
                    {
                        dtHeader.Rows[0]["DiscountOnBill"] = "0";
                        dtHeader.Rows[0]["UserName"] = Username;
                        dtHeader.Rows[0]["LoginName"] = LoginName;
                    }
                }
                if (dtHeader.Columns.Contains("ParentComp") == false) dtHeader.Columns.Add("ParentComp");
                if (dtHeader.Columns.Contains("IsServiceTax") == false) dtHeader.Columns.Add("IsServiceTax");
                if (dtHeader.Columns.Contains("Panel_ID") == false) dtHeader.Columns.Add("Panel_ID");

                DataTable dtPnl = StockReports.GetDataTable("Select pm.Company_Name,Pm.ParentID,pnl.IsServiceTax,"+
                    " pnl.Panel_ID from (Select Panel_ID,ParentID from patient_medical_history pmh where "+
                    " transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "')Pmh inner join "+
                    " f_panel_master pm on pm.Panel_ID = pmh.ParentID inner join f_panel_master pnl on pmh.Panel_ID = pnl.Panel_ID");

                if (dtPnl != null && dtPnl.Rows.Count > 0)
                {
                    dtHeader.Rows[0]["ParentComp"] = dtPnl.Rows[0]["Company_Name"].ToString();
                    if (dtPnl.Rows[0]["IsServiceTax"].ToString().ToUpper() == "TRUE")
                        dtHeader.Rows[0]["IsServiceTax"] = "1";
                    else if (dtPnl.Rows[0]["IsServiceTax"].ToString().ToUpper() == "FALSE")
                        dtHeader.Rows[0]["IsServiceTax"] = "0";
                    else
                        dtHeader.Rows[0]["IsServiceTax"] = dtPnl.Rows[0]["IsServiceTax"].ToString();

                    if (dtPnl.Rows[0]["Panel_ID"].ToString().ToUpper() == "TRUE")
                        dtHeader.Rows[0]["Panel_ID"] = "1";
                    else if (dtPnl.Rows[0]["Panel_ID"].ToString().ToUpper() == "FALSE")
                        dtHeader.Rows[0]["Panel_ID"] = "0";
                    else
                        dtHeader.Rows[0]["Panel_ID"] = dtPnl.Rows[0]["Panel_ID"].ToString();
                }

                dtHeader.Rows[0]["ClaimNo"] = StockReports.ExecuteScalar("Select ClaimNo from f_ipdAdjustment where Transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");
            }


            if (dtNetAmtWord != null && dtNetAmtWord.Rows[0]["DiscountReason"].ToString() == "")
            {
                DataRow[] rowDis = dtVerLedgerTnxDetails.Select("DiscountReason <>''");

                if (rowDis.Length > 0)
                {
                    foreach (DataRow row in rowDis)
                    {
                        dtNetAmtWord.Rows[0]["DiscountReason"] = row["DiscountReason"].ToString();
                        break;
                    }
                }
            }
            DataView dv = dtVerLedgerTnxDetails.DefaultView;
            dv.Sort = "DisplayPriority";
            dtVerLedgerTnxDetails = dv.ToTable();

            dtNetAmtWord.Rows[0]["IsBilledClosed"] = StockReports.ExecuteScalar("Select IsBilledClosed from f_ipdadjustment where transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");


            
            if (dtReceipt != null && dtReceipt.Columns.Contains("PanelName") == false) dtReceipt.Columns.Add("PanelName");
            float NetAmtReceived = 0f;
            if (dtReceipt != null && dtReceipt.Rows.Count > 0)
            {
                string PanelName = AQ.GetPanelByID(dtLedgerTnx.Rows[0]["Panel_ID"].ToString()).Rows[0][0].ToString();

                for (int i = 0; i < dtReceipt.Rows.Count; i++)
                {
                    dtReceipt.Rows[i]["PanelName"] = PanelName;
                }

                NetAmtReceived = Util.GetFloat(Math.Round(Util.GetDecimal(dtReceipt.Compute("sum(AmountPaid)", ""))));
            }

            dtNetAmtWord.Rows[0]["ReceivedAmt"] = NetAmtReceived.ToString();

            string Transaction_id = dtLedgerTnx.Rows[0]["Transaction_ID"].ToString();

            DataTable dtdebit = new DataTable();
            dtdebit.TableName = "Debit";
            dtdebit = getDebit(Transaction_id);
            dtdebit.TableName = "Debit";


            if (dtdebit != null && dtdebit.Rows.Count == 0)
            {
                DataRow dr = dtdebit.NewRow();
                dr["NetAmount"] = "0";
                dr["Transaction_ID"] = Transaction_id;
                dr["CrDrNo"] = "";
                dtdebit.Rows.Add(dr);
                dtdebit.AcceptChanges();
            }

            DataTable dtCredit = new DataTable();
            dtCredit.TableName = "Crebit";
            dtCredit = getCredit(Transaction_id);
            dtCredit.TableName = "Crebit";



            if (dtCredit != null && dtCredit.Rows.Count == 0)
            {
                DataRow dr = dtCredit.NewRow();
                dr["NetAmount"] = "0";
                dr["Transaction_ID"] = Transaction_id;
                dr["CrDrNo"] = "";
                dtCredit.Rows.Add(dr);
                dtCredit.AcceptChanges();
            }
            //=============================================================================

            

      

            ds.Tables.Add(dtLedgerTnx.Copy());
            ds.Tables.Add(dtVerLedgerTnxDetails);

            DataColumn dc = new DataColumn();
            dc.ColumnName = "lang_code";
            dc.DefaultValue = GetGlobalResourceObject("Resource", "Lang_Code").ToString();
            dtHeader.Columns.Add(dc);
            ds.Tables.Add(dtHeader);
            ds.Tables.Add(dtNetAmtWord);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "lang_code";
            dc1.DefaultValue = GetGlobalResourceObject("Resource", "Lang_Code").ToString();
            dtReceipt.Columns.Add(dc1);
            ds.Tables.Add(dtReceipt);

            //changes vipin
            //===================================================
            ds.Tables.Add(dtCredit);
            ds.Tables.Add(dtdebit);
            //===================================================

            //obj1.Load(Server.MapPath(@"~\Reports\Reports\BillReportDetails.rpt"));
            // obj1.SetDataSource(ds);

            string Panel_ID = StockReports.GetDataTable("Select ReferenceCode from f_panel_master Where Panel_ID=(Select Panel_ID from patient_medical_history where Transaction_id='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "')").Rows[0][0].ToString();
            string str = "Select LTD.LedgerTransactionNo,idt.SubItemName,idt.Rate as SubItemRate,idt.ItemID from (Select * from f_ledgertnxdetail where Transaction_ID = '" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "' AND Isverified <> 2 group by ItemID) ltd inner join f_itemdetail idt on idt.ItemID = ltd.ItemID and idt.IsActive = 1 and idt.Panel_ID=" + Panel_ID + " order by LTD.ItemID,date(LTD.EntryDate)";
            DataTable dtItemdt = StockReports.GetDataTable(str);

            dtItemdt.TableName = "ItemDetail";
            ds.Tables.Add(dtItemdt.Copy());
            //this.CrystalReportViewer1.ReportSource = obj1;
            //this.CrystalReportViewer1.DataBind();

            obj1.Load(Server.MapPath(@"~\Reports\Reports\BillReportDetails.rpt"));
            obj1.SetDataSource(ds);

            //this.CrystalReportViewer1.ReportSource = obj1;
            //this.CrystalReportViewer1.DataBind();

            //ds.WriteXml("d:\\BillDetails.xml");

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);

            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
    

    
    public void SummaryBill()
    {
        try
        {

            DataTable dtVerLedgerTnxDetails = new DataTable();
            if (!dtLedgerTnxDetails.Columns.Contains("ShowSummary"))
            {
                dtLedgerTnxDetails.Columns.Add("ShowSummary");
            }

            dtVerLedgerTnxDetails = dtLedgerTnxDetails.Clone();

            DataTable dtNetAmtWord = new DataTable();

            if (Session["dtNetAmtWord"] != null)
            {
                dtNetAmtWord = ((DataTable)Session["dtNetAmtWord"]).Copy();
                if (dtNetAmtWord.Columns.Contains("PanelAppRemarks") == false) dtNetAmtWord.Columns.Add("PanelAppRemarks");

                dtNetAmtWord.Rows[0]["PanelAppRemarks"] = StockReports.ExecuteScalar("Select PanelAppRemarks from f_ipdAdjustment where Transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");


                if (dtNetAmtWord.Columns.Contains("PanelApprovedAmt") == false) dtNetAmtWord.Columns.Add("PanelApprovedAmt");
                dtNetAmtWord.Rows[0]["PanelApprovedAmt"] = StockReports.ExecuteScalar("Select IFNULL(PanelApprovedAmt,0)PanelApprovedAmt from f_ipdAdjustment where Transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");


                string NetAmount = dtNetAmtWord.Rows[0]["NetAmount"].ToString();

                if (NetAmount == "") NetAmount = "0";

                if (Util.GetFloat(NetAmount) < 0)
                {
                    NetAmount = NetAmount.Remove(0, 1);
                }

                NetAmount = Util.GetString(Util.GetDecimal(NetAmount));

                dtNetAmtWord.Rows[0]["NetAmountWord"] = StockReports.ChangeNumericToWords(Util.GetString((Util.GetDecimal(dtNetAmtWord.Rows[0]["NetAmount"].ToString()))));
                dtNetAmtWord.Rows[0]["IsBilledClosed"] = StockReports.ExecuteScalar("Select IsBilledClosed from f_ipdadjustment where transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");

            }

            DataRow[] drLtnxDetails = dtLedgerTnxDetails.Select("IsVerified=1 and IsPackage =0");
            string Panel_ID = StockReports.ExecuteScalar("Select Panel_ID from patient_medical_history pmh where transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");
            foreach (DataRow dr in drLtnxDetails)
            {
                if (dr["DisplayName"].ToString() == "")
                {
                    dr["DisplayName"] = "#";
                }
                
                    dr["ShowSummary"] = 0;
                

                dtVerLedgerTnxDetails.ImportRow(dr);
            }


            DataTable dtHeader = IPDBilling.getPatientHeaderForReport1(dtLedgerTnx.Rows[0]["Patient_id"].ToString(), dtLedgerTnx.Rows[0]["Transaction_ID"].ToString());
            dtHeader.TableName = "Header";
            dtLedgerTnx.TableName = "LedgerTnx";
            dtVerLedgerTnxDetails.TableName = "LedgerTnxDetails";

            if (dtHeader != null && dtHeader.Rows.Count > 0)
            {
                if (dtHeader.Columns.Contains("DiscountOnBill") == false) dtHeader.Columns.Add("DiscountOnBill");
                if (dtHeader.Columns.Contains("UserName") == false) dtHeader.Columns.Add("UserName");
                if (dtHeader.Columns.Contains("LoginName") == false) dtHeader.Columns.Add("LoginName");

                AllQuery AlQ = new AllQuery();
                DataTable dt = AlQ.GetPatientAdjustmentDetails(dtLedgerTnx.Rows[0]["Transaction_ID"].ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataTable dtuser = AlQ.GetUserinformation(dt.Rows[0]["UserID"].ToString().Trim());
                    string Username = "", LoginName = "";
                    if (dtuser != null && dtuser.Rows.Count > 0)
                    {
                        Username = dtuser.Rows[0]["UserName"].ToString();
                        LoginName = dtuser.Rows[0]["LoginName"].ToString();
                    }
                    else
                    {
                        Username = Session["LoginName"].ToString();
                        LoginName = Session["UserName"].ToString();
                    }


                    if (dt.Rows[0]["DiscountOnBill"].ToString().Trim() != "")
                    {
                        dtHeader.Rows[0]["DiscountOnBill"] = dt.Rows[0]["DiscountOnBill"].ToString().Trim();
                        dtHeader.Rows[0]["UserName"] = Username;
                        dtHeader.Rows[0]["LoginName"] = LoginName;
                    }
                    else
                    {
                        dtHeader.Rows[0]["DiscountOnBill"] = "0";
                        dtHeader.Rows[0]["UserName"] = Username;
                        dtHeader.Rows[0]["LoginName"] = LoginName;
                    }
                }
                if (dtHeader.Columns.Contains("ParentComp") == false) dtHeader.Columns.Add("ParentComp");
                if (dtHeader.Columns.Contains("IsServiceTax") == false) dtHeader.Columns.Add("IsServiceTax");
                if (dtHeader.Columns.Contains("Panel_ID") == false) dtHeader.Columns.Add("Panel_ID");

                //DataTable dtPnl = StockReports.GetDataTable("Select pm.Company_Name,pnl.ParentID,pnl.IsServiceTax,pnl.Panel_ID from f_panel_master pm inner join f_panel_master pnl on pm.Panel_ID = pnl.ParentID where pnl.Panel_ID='" + dtLedgerTnx.Rows[0]["Panel_ID"].ToString() + "'");
                DataTable dtPnl = StockReports.GetDataTable("Select pm.Company_Name,Pm.ParentID,pnl.IsServiceTax,pnl.Panel_ID from (Select Panel_ID,ParentID from patient_medical_history pmh where transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "')Pmh inner join f_panel_master pm on pm.Panel_ID = pmh.ParentID inner join f_panel_master pnl on pmh.Panel_ID = pnl.Panel_ID");

                if (dtPnl != null && dtPnl.Rows.Count > 0)
                {
                    dtHeader.Rows[0]["ParentComp"] = dtPnl.Rows[0]["Company_Name"].ToString();
                    if (dtPnl.Rows[0]["IsServiceTax"].ToString().ToUpper() == "TRUE")
                        dtHeader.Rows[0]["IsServiceTax"] = "1";
                    else if (dtPnl.Rows[0]["IsServiceTax"].ToString().ToUpper() == "FALSE")
                        dtHeader.Rows[0]["IsServiceTax"] = "0";
                    else
                        dtHeader.Rows[0]["IsServiceTax"] = dtPnl.Rows[0]["IsServiceTax"].ToString();

                    if (dtPnl.Rows[0]["Panel_ID"].ToString().ToUpper() == "TRUE")
                        dtHeader.Rows[0]["Panel_ID"] = "1";
                    else if (dtPnl.Rows[0]["Panel_ID"].ToString().ToUpper() == "FALSE")
                        dtHeader.Rows[0]["Panel_ID"] = "0";
                    else
                        dtHeader.Rows[0]["Panel_ID"] = dtPnl.Rows[0]["Panel_ID"].ToString();
                }

                dtHeader.Rows[0]["ClaimNo"] = StockReports.ExecuteScalar("Select ClaimNo from f_ipdAdjustment where Transaction_ID='" + dtLedgerTnx.Rows[0]["Transaction_ID"].ToString() + "'");
            }


            if (dtNetAmtWord != null && dtNetAmtWord.Rows[0]["DiscountReason"].ToString() == "")
            {
                DataRow[] rowDis = dtVerLedgerTnxDetails.Select("DiscountReason <>''");

                if (rowDis.Length > 0)
                {
                    foreach (DataRow row in rowDis)
                    {
                        dtNetAmtWord.Rows[0]["DiscountReason"] = row["DiscountReason"].ToString();
                        break;
                    }
                }
            }

            DataView dv = dtVerLedgerTnxDetails.DefaultView;
            dv.Sort = "DisplayPriority";
            dtVerLedgerTnxDetails = dv.ToTable();


            float NetAmtReceived = 0f;
            if (dtReceipt != null && dtReceipt.Columns.Contains("PanelName") == false) dtReceipt.Columns.Add("PanelName");

            if (dtReceipt != null && dtReceipt.Rows.Count > 0)
            {                
                string PanelName = AQ.GetPanelByID(dtLedgerTnx.Rows[0]["Panel_ID"].ToString()).Rows[0][0].ToString();

                for (int i = 0; i < dtReceipt.Rows.Count; i++)
                {
                    dtReceipt.Rows[i]["PanelName"] = PanelName;
                }


                NetAmtReceived = Util.GetFloat((Util.GetDecimal(dtReceipt.Compute("sum(AmountPaid)", ""))));
            }

            dtNetAmtWord.Rows[0]["ReceivedAmt"] = NetAmtReceived.ToString();

            //Remove HS Items which has no service item set
            if (dtLedgerTnx.Rows[0]["BillNo"].ToString() != "")
            {
                if (Util.GetDateTime(dtHeader.Rows[0]["BillDate"]).Date > Util.GetDateTime("02-Jan-2012").Date)
                {

                    DataRow[] HsRow = dtVerLedgerTnxDetails.Select("Type_ID='HS'");
                    foreach (DataRow row in HsRow)
                    {
                        if (row["ServiceItemID"].ToString() == "")
                        {
                            //dtVerLedgerTnxDetails.Rows.Remove(row);
                        }
                    }
                    dtVerLedgerTnxDetails.AcceptChanges();
                }
            }
            else if (dtLedgerTnx.Rows[0]["BillNo"].ToString() == "")
            {
                DataRow[] HsRow = dtVerLedgerTnxDetails.Select("Type_ID='HS'");
                foreach (DataRow row in HsRow)
                {
                    if (row["ServiceItemID"].ToString() == "")
                    {
                        //dtVerLedgerTnxDetails.Rows.Remove(row);
                    }
                }
                dtVerLedgerTnxDetails.AcceptChanges();

            }

            //changes vipin
            //=========================================================================
            string Transaction_id = dtLedgerTnx.Rows[0]["Transaction_ID"].ToString();

            DataTable dtdebit = new DataTable();
            dtdebit.TableName = "Debit";
            dtdebit = getDebit(Transaction_id);
            dtdebit.TableName = "Debit";


            if (dtdebit != null && dtdebit.Rows.Count == 0)
            {
                 DataRow dr = dtdebit.NewRow();
                 dr["NetAmount"] = "0";
                 dr["Transaction_ID"] = Transaction_id;
                 dr["CrDrNo"] = "";
                 dtdebit.Rows.Add(dr);
                 dtdebit.AcceptChanges();
            }

            DataTable dtCredit = new DataTable();
            dtCredit.TableName = "Crebit";
            dtCredit= getCredit(Transaction_id);
            dtCredit.TableName = "Crebit";
            

            
            if (dtCredit != null && dtCredit.Rows.Count == 0)
            {
                DataRow dr = dtCredit.NewRow();
                dr["NetAmount"] = "0";
                dr["Transaction_ID"] = Transaction_id;
                dr["CrDrNo"] = "";
                dtCredit.Rows.Add(dr);
                dtCredit.AcceptChanges();
            }
           //=============================================================================



            ds.Tables.Add(dtLedgerTnx.Copy());
            ds.Tables.Add(dtVerLedgerTnxDetails);
            ds.Tables.Add(dtNetAmtWord);

            DataColumn dc = new DataColumn();
            dc.ColumnName = "lang_code";
            dc.DefaultValue = GetGlobalResourceObject("Resource", "Lang_Code").ToString();
            dtHeader.Columns.Add(dc);
            ds.Tables.Add(dtHeader);

            DataColumn dc1 = new DataColumn();
            dc1.ColumnName = "lang_code";
            dc1.DefaultValue = GetGlobalResourceObject("Resource", "Lang_Code").ToString();
            dtReceipt.Columns.Add(dc1);
            ds.Tables.Add(dtReceipt);
            
            //changes vipin
            //===================================================
            ds.Tables.Add(dtCredit);
            ds.Tables.Add(dtdebit);
            //===================================================


          //  ds.WriteXmlSchema(@"d:\BillSummary.xml");


            obj1.Load(Server.MapPath(@"~\Reports\Reports\BillReportSummary.rpt"));
            obj1.SetDataSource(ds);

          //  this.CrystalReportViewer1.ReportSource = obj1;
          //  this.CrystalReportViewer1.DataBind();

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);

            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        //ds.WriteXml("C:\\BillSummary.xml");

    }

    private DataTable getCredit(string Transaction_id)
    {
      
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sum(Amount)NetAmount,Transaction_id,CONVERT(GROUP_CONCAT(CrDrNo),CHAR)CrDrNo FROM f_drcrnote ");
        sb.Append(" WHERE CRDR='CR01' AND Transaction_id='" + Transaction_id + "' group by Transaction_id");
        return StockReports.GetDataTable(sb.ToString()).Copy();

    }

    private DataTable getDebit(string Transaction_id)
    {        
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sum(Amount)NetAmount,Transaction_id,CONVERT(GROUP_CONCAT(CrDrNo),CHAR)CrDrNo FROM f_drcrnote  ");
        sb.Append(" WHERE CRDR='DR01' AND Transaction_id='" + Transaction_id + "' group by Transaction_id");
        return StockReports.GetDataTable(sb.ToString()).Copy();
    }

    public void SummaryBillProvisional()
    {
        try
        {

            DataTable dtVerLedgerTnxDetails = new DataTable();
            if (!dtLedgerTnxDetails.Columns.Contains("ShowSummary"))
            {
                dtLedgerTnxDetails.Columns.Add("ShowSummary");
            }

            dtVerLedgerTnxDetails = dtLedgerTnxDetails.Clone();

            DataTable dtNetAmtWord = new DataTable();

            if (Session["dtNetAmtWord"] != null)
            {
                dtNetAmtWord = ((DataTable)Session["dtNetAmtWord"]).Copy();
                //Session.Remove("dtNetAmtWord");

                string NetAmount = dtNetAmtWord.Rows[0]["NetAmount"].ToString();

                if (NetAmount == "") NetAmount = "0";

                if (Util.GetFloat(NetAmount) < 0)
                {
                    NetAmount = NetAmount.Remove(0, 1);
                }

                NetAmount = Util.GetString((Util.GetDecimal(NetAmount)));


                //if (dtNetAmtWord.Rows[0]["ShowReceipt"].ToString() == "0")
                //{
                //    NetAmount = Util.GetString(Util.GetFloat(NetAmount) + Util.GetFloat(dtNetAmtWord.Rows[0]["ReceivedAmt"].ToString()));
                //}
                //dtNetAmtWord.Rows[0]["NetAmountWord"] = changeNumericToWords(NetAmount);
                dtNetAmtWord.Rows[0]["NetAmountWord"] = StockReports.ChangeNumericToWords(Util.GetString((Util.GetDecimal(dtNetAmtWord.Rows[0]["BilledAmt"].ToString()))));

            }

            DataRow[] drLtnxDetails = dtLedgerTnxDetails.Select("IsVerified=1 and IsPackage =0");
            foreach (DataRow dr in drLtnxDetails)
            {
                if (dr["DisplayName"].ToString() == "")
                {
                    dr["DisplayName"] = "#";
                }
                if (dr["DisplayName"].ToString() == "Consultant Visit Fee" || dr["DisplayName"].ToString() == "Room Charges" || dr["DisplayName"].ToString() == "Cardiac Investigation" || dr["DisplayName"].ToString() == "EQUIPMENT CHARGES" || dr["DisplayName"].ToString() == "INJECTION CHARGES" || dr["DisplayName"].ToString() == "Package" || dr["DisplayName"].ToString() == "Procedure Charges" || dr["DisplayName"].ToString() == "STENT CHARGES" || dr["DisplayName"].ToString() == "OTHER CHARGES" || dr["DisplayName"].ToString() == "Pro Charges" || dr["DisplayName"].ToString() == "RMO CHARGES")
                {
                    if (dr["DisplayName"].ToString() == "Consultant Visit Fee")
                    {
                        dr["ItemName"] = "Dr. " + dr["ItemName"].ToString();
                    }
                    dr["ShowSummary"] = 1;
                }
                else
                {
                    dr["ShowSummary"] = 0;
                }

                dtVerLedgerTnxDetails.ImportRow(dr);
            }
            DataTable dtHeader = IPDBilling.getPatientHeaderForReport1(dtLedgerTnx.Rows[0]["Patient_id"].ToString(), dtLedgerTnx.Rows[0]["Transaction_ID"].ToString());
            //DataTable dtHeader2 = 
            dtHeader.TableName = "Header";
            dtLedgerTnx.TableName = "LedgerTnx";
            dtVerLedgerTnxDetails.TableName = "LedgerTnxDetails";


            if (dtHeader != null && dtHeader.Rows.Count > 0)
            {
                if (dtHeader.Columns.Contains("DiscountOnBill") == false) dtHeader.Columns.Add("DiscountOnBill");
                if (dtHeader.Columns.Contains("UserName") == false) dtHeader.Columns.Add("UserName");
                if (dtHeader.Columns.Contains("LoginName") == false) dtHeader.Columns.Add("LoginName");

                AllQuery AlQ = new AllQuery();
                DataTable dt = AlQ.GetPatientAdjustmentDetails(dtLedgerTnx.Rows[0]["Transaction_ID"].ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataTable dtuser = AlQ.GetUserinformation(dt.Rows[0]["UserID"].ToString().Trim());
                    string Username = "", LoginName = "";
                    if (dtuser != null && dtuser.Rows.Count > 0)
                    {
                        Username = dtuser.Rows[0]["UserName"].ToString();
                        LoginName = dtuser.Rows[0]["LoginName"].ToString();
                    }
                    else
                    {
                        Username = Session["LoginName"].ToString();
                        LoginName = Session["UserName"].ToString();
                    }


                    if (dt.Rows[0]["DiscountOnBill"].ToString().Trim() != "")
                    {
                        dtHeader.Rows[0]["DiscountOnBill"] = dt.Rows[0]["DiscountOnBill"].ToString().Trim();
                        dtHeader.Rows[0]["UserName"] = Username;
                        dtHeader.Rows[0]["LoginName"] = LoginName;
                    }
                    else
                    {
                        dtHeader.Rows[0]["DiscountOnBill"] = "0";
                        dtHeader.Rows[0]["UserName"] = Username;
                        dtHeader.Rows[0]["LoginName"] = LoginName;
                    }
                }
            }
            if (dtNetAmtWord != null && dtNetAmtWord.Rows[0]["DiscountReason"].ToString() == "")
            {
                DataRow[] rowDis = dtVerLedgerTnxDetails.Select("DiscountReason <>''");

                if (rowDis.Length > 0)
                {
                    foreach (DataRow row in rowDis)
                    {
                        dtNetAmtWord.Rows[0]["DiscountReason"] = row["DiscountReason"].ToString();
                        break;
                    }
                }
            }

            DataView dv = dtVerLedgerTnxDetails.DefaultView;
            dv.Sort = "DisplayPriority";
            dtVerLedgerTnxDetails = dv.ToTable();

            ds.Tables.Add(dtLedgerTnx.Copy());
            ds.Tables.Add(dtVerLedgerTnxDetails);
            ds.Tables.Add(dtHeader);

            ds.Tables.Add(dtNetAmtWord);

            DataTable dtReceipt = new DataTable();
            AllQuery AQ = new AllQuery();
            dtReceipt = AQ.GetPatientReceipt(dtLedgerTnx.Rows[0]["Transaction_ID"].ToString()).Copy();

            if (dtReceipt != null && dtReceipt.Rows.Count > 0)
            {
                dtReceipt.Columns.Add("PanelName");
                string PanelName = AQ.GetPanelByID(dtLedgerTnx.Rows[0]["Panel_ID"].ToString()).Rows[0][0].ToString();

                for (int i = 0; i < dtReceipt.Rows.Count; i++)
                {
                    dtReceipt.Rows[i]["PanelName"] = PanelName;
                }

                ds.Tables.Add(dtReceipt);

            }
            else if (dtReceipt != null && dtReceipt.Rows.Count == 0)
            {
                dtReceipt.Columns.Add("PanelName");
                DataRow dr1 = dtReceipt.NewRow();
                dr1[0] = "";
                dr1[1] = "0";
                dr1[2] = "";
                dr1[3] = "";
                dr1[4] = "";
                dr1[5] = "";
                dtReceipt.Rows.Add(dr1);
                ds.Tables.Add(dtReceipt);
            }

          //  ds.WriteXml(@"c:\BillSummary.xml");

            obj1.Load(Server.MapPath(@"~\Reports\Reports\BillReportSummary.rpt"));
            obj1.SetDataSource(ds);

         //   this.CrystalReportViewer1.ReportSource = obj1;
           // this.CrystalReportViewer1.DataBind();

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);

            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        ds.WriteXml("C:\\BillSummary.xml");

    }

    
    public void PackageBreakup()
    {

        try
        {
            DataTable dtHeader = IPDBilling.getPatientHeaderForReport(dtLedgerTnx.Rows[0]["Patient_id"].ToString(), dtLedgerTnx.Rows[0]["Transaction_ID"].ToString());
            //DataTable dtHeader2 = 
            dtHeader.TableName = "Header";
            dtPackage.TableName = "dtPackage";
            dtPackageDetail.TableName = "dtPackageDetail";

            DataView dv = dtPackage.DefaultView;
            dv.Sort = "DisplayPriority";
            dtPackage = dv.ToTable();



            ds.Tables.Add(dtPackage.Copy());
            ds.Tables.Add(dtPackageDetail);
            ds.Tables.Add(dtHeader);
            ds.Tables.Add(dtNetAmtWord);
          //  ds.WriteXml("E:\\PackageDetails.xml");

            obj1.Load(Server.MapPath(@"~\Reports\Reports\BillPkgDetails.rpt"));
            obj1.SetDataSource(ds);

           // this.CrystalReportViewer1.ReportSource = obj1;
           // this.CrystalReportViewer1.DataBind();

            System.IO.MemoryStream m = (System.IO.MemoryStream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);

            Response.ClearContent();
            Response.ClearHeaders();
            Response.Buffer = true;
            Response.ContentType = "application/pdf";
            Response.BinaryWrite(m.ToArray());
          
            
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }


    private String changeToWords(String numb, bool isCurrency)
    {
        String val = "", wholeNo = numb, points = "", andStr = "", pointStr = "";
        String endStr = (isCurrency) ? ("Only") : ("");
        try
        {
            int decimalPlace = numb.IndexOf(".");
            if (decimalPlace > 0)
            {
                wholeNo = numb.Substring(0, decimalPlace);
                points = numb.Substring(decimalPlace + 1);
                if (Convert.ToInt32(points) > 0)
                {
                    andStr = (isCurrency) ? ("and") : ("point");// just to separate whole numbers from points/cents
                    endStr = (isCurrency) ? ("Cents " + endStr) : ("");
                    pointStr = translateCents(points);
                }
            }
            val = String.Format("{0} {1}{2} {3}", translateWholeNumber(wholeNo).Trim(), andStr, pointStr, endStr);
        }
        catch { ;}
        return val;
    }
    private String translateWholeNumber(String number)
    {
        string word = "";
        try
        {
            bool beginsZero = false;//tests for 0XX
            bool isDone = false;//test if already translated
            double dblAmt = (Convert.ToDouble(number));
            //if ((dblAmt > 0) && number.StartsWith("0"))
            if (dblAmt > 0)
            {//test for zero or digit zero in a nuemric
                beginsZero = number.StartsWith("0");

                int numDigits = number.Length;
                int pos = 0;//store digit grouping
                String place = "";//digit grouping name:hundres,thousand,etc...
                switch (numDigits)
                {
                    case 1://ones' range
                        word = ones(number);
                        isDone = true;
                        break;
                    case 2://tens' range
                        word = tens(number);
                        isDone = true;
                        break;
                    case 3://hundreds' range
                        pos = (numDigits % 3) + 1;
                        place = " Hundred ";
                        break;
                    case 4://thousands' range
                    case 5:
                    case 6:
                        pos = (numDigits % 4) + 1;
                        place = " Thousand ";
                        break;
                    case 7://lakhs' range
                    case 8:
                        pos = (numDigits % 6) + 1;
                        place = " Lakh(s) ";
                        break;
                    case 9:                        
                    case 10://Billions's range
                        pos = (numDigits % 8) + 1;
                        place = " Crore(s) ";
                        break;
                    //add extra case options for anything above Billion...
                    default:
                        isDone = true;
                        break;
                }
                if (!isDone)
                {//if transalation is not done, continue...(Recursion comes in now!!)
                    word = translateWholeNumber(number.Substring(0, pos)) + place + translateWholeNumber(number.Substring(pos));
                    //check for trailing zeros
                    if (beginsZero) word = " and " + word.Trim();
                }
                //ignore digit grouping names
                if (word.Trim().Equals(place.Trim())) word = "";
            }
        }
        catch { ;}
        return word.Trim();
    }
    private String tens(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = null;
        switch (digt)
        {
            case 10:
                name = "Ten";
                break;
            case 11:
                name = "Eleven";
                break;
            case 12:
                name = "Twelve";
                break;
            case 13:
                name = "Thirteen";
                break;
            case 14:
                name = "Fourteen";
                break;
            case 15:
                name = "Fifteen";
                break;
            case 16:
                name = "Sixteen";
                break;
            case 17:
                name = "Seventeen";
                break;
            case 18:
                name = "Eighteen";
                break;
            case 19:
                name = "Nineteen";
                break;
            case 20:
                name = "Twenty";
                break;
            case 30:
                name = "Thirty";
                break;
            case 40:
                name = "Fourty";
                break;
            case 50:
                name = "Fifty";
                break;
            case 60:
                name = "Sixty";
                break;
            case 70:
                name = "Seventy";
                break;
            case 80:
                name = "Eighty";
                break;
            case 90:
                name = "Ninety";
                break;
            default:
                if (digt > 0)
                {
                    name = tens(digit.Substring(0, 1) + "0") + " " + ones(digit.Substring(1));
                }
                break;
        }
        return name;
    }
    private String ones(String digit)
    {
        int digt = Convert.ToInt32(digit);
        String name = "";
        switch (digt)
        {
            case 1:
                name = "One";
                break;
            case 2:
                name = "Two";
                break;
            case 3:
                name = "Three";
                break;
            case 4:
                name = "Four";
                break;
            case 5:
                name = "Five";
                break;
            case 6:
                name = "Six";
                break;
            case 7:
                name = "Seven";
                break;
            case 8:
                name = "Eight";
                break;
            case 9:
                name = "Nine";
                break;
        }
        return name;
    }
    private String translateCents(String cents)
    {
        String cts = "", digit = "", engOne = "";
        for (int i = 0; i < cents.Length; i++)
        {
            digit = cents[i].ToString();
            if (digit.Equals("0"))
            {
                engOne = "Zero";
            }
            else
            {
                engOne = ones(digit);
            }
            cts += " " + engOne;
        }
        return cts;
    }

    protected void Page_UnLoad(object sender, EventArgs e)
    {
        if (obj1 != null)
        {
            obj1.Close();
            obj1.Dispose();
        }
    }

}
