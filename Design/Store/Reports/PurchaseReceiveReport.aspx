<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PurchaseReceiveReport.aspx.cs" Inherits="Design_Store_PurchaseReceiveReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {
            showhidefilter(1, 1, 1, 1, 1, 1, 1, 1, 0, 1);
            //showhidefilter(center, department, supplier, category, subcategory, item, fromdate, todate,reportype);
        });
        function getsearchparameter() {
            if (Getmultiselectvalue($('#lstcenter')) == '')
                return [{ erroMessage: 'Please Select Center', type: 'V' }];
            if (Getmultiselectvalue($('#lstdepartment')) == '')
                return [{ erroMessage: 'Please Select Department', type: 'V' }];
          
            var searchparameter = new Array();
            searchparameter[0] = Getmultiselectvalue($('#lstcenter'));
            searchparameter[1] = Getmultiselectvalue($('#lstdepartment'));
            searchparameter[2] = Getmultiselectvalue($('#lstCategory'));
            searchparameter[3] = Getmultiselectvalue($('#lstsubgroup'));
            searchparameter[4] = Getmultiselectvalue($('#lstitems'));
            searchparameter[5] = Getmultiselectvalue($('#lstsupplier'));;
            searchparameter[6] = $('#ddlDateType').val();
            searchparameter[7] = $('#ddlReferenceNo').val();
            searchparameter[8] = $('#txtReferenceNo').val();
            searchparameter[9] = $('#ddlItemType').val();
            searchparameter[10] = $('#ddlTransType').val();
            searchparameter[11] = $('#txtdatefrom').val();
            searchparameter[12] = $('#txtdateTo').val();
            searchparameter[13] = $('#ddlReportType').val();
            searchparameter[14] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "STO00001" : "STO00002";
            return searchparameter;
        }
        var reportprint = function () {
            getreport('PurchaseReceiveReport.aspx/Store_Get_SupplierPurchaseAndReturn');

            //  url: "../../Design/Store/Services/CommonService.asmx/BindItems",
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>GRN Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server"  CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
             <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />

            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">Date Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <select id="ddlDateType">
                                   <option value="G">GRN Date</option>
                                   <option value="P">GRN Post Date</option>
                                   <option value="I">Invoice Date</option>
                                   <option value="C">Delivery Note Date</option>
                               </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Reference No. Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlReferenceNo">
                                <option value="G">GRN No.</option>
                                <option value="I">Invoice No.</option>
                                <option value="C">Delivery Note No.</option>
                                <option value="P">PO No.</option>
                                <option value="V">Vendor Return No.</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Reference No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtReferenceNo" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Item Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlItemType">
                                 <option value="ALL">ALL</option>
                                <option value="P" selected="selected">Posted</option>
                                <option value="R">Rejected</option>
                                <option value="C">Canceled</option>
                            </select>
                        </div>
                           <div class="col-md-3">
                            <label class="pull-left">Transaction Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlTransType">
                                <option value="B">Both</option>
                                <option value="P">Purchase</option>
                                <option value="R">Return</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Report Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <select id="ddlReportType">
                               <option value="D">Detailed</option>
                               <option value="S">Summary</option>
                           </select>
                        </div>
                    </div>
                </div></div>

            </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>
    </div>
</asp:Content>
