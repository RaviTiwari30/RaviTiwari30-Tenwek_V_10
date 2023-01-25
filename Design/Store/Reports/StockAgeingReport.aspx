<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="StockAgeingReport.aspx.cs" Inherits="Design_Store_Report_StockAgeingReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UCAgeingBuckets.ascx" TagName="wuc_AgeingBuckets" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            showhidefilter(1, 1, 0, 1, 1, 1, 0, 1, 0, 1);
            $("#spnControlforStore").text('1');
            //showhidefilter(center, department, supplier, category, subcategory, items, fromdate, todate, reporttype, StoreType)
            $("#ddlAgeingWho").val("Stock").attr('disabled', true);
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
            searchparameter[5] = $('#txtdateTo').val();
            searchparameter[6] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "STO00001" : "STO00002";
            searchparameter[7] = $('input[type=radio][name=format]:checked').val() == "PDF" ? "PDF" : "EXCEL";
            searchparameter[8] =  $('#ddlBucketType').val();
            searchparameter[9] = $('#ddlAgeingWho').val();

            return searchparameter;
        }
        var reportprint = function () {
            getreport('StockAgeingReport.aspx/Store_Get_StockAgeing');

            //  url: "../../Design/Store/Services/CommonService.asmx/BindItems",
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Stock Ageing Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />
            <div style="margin-left:10px;"><uc2:wuc_AgeingBuckets ID="AgeingBuckets" runat="server" /></div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnsearch" onclick="reportprint()" value="Report" />
        </div>
    </div>
</asp:Content>

