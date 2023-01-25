<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="StockLedgerReport.aspx.cs" Inherits="Design_Finance_StockLedgerReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            showhidefilter(1, 1, 0, 1, 1, 1, 1, 1, 0, 1);
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
            searchparameter[5] = $('#txtdatefrom').val();
            searchparameter[6] = $('#txtdateTo').val();
            searchparameter[7] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "STO00001" : "STO00002";
            return searchparameter;
        }
        var reportprint = function () {
            getreport('../../../Design/Store/Reports/StockLedgerReport.aspx/Store_Get_StockLedger');

            //  url: "../../Design/Store/Services/CommonService.asmx/BindItems",
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div style="text-align: center;">
                <b>Stock Ledger Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div> </div><div class="POuter_Box_Inventory">
             <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
              <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>
    </div>
</asp:Content>
