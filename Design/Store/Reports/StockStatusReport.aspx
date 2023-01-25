<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="StockStatusReport.aspx.cs" Inherits="Design_Store_StockStatusReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript">
         $(function () {
             showhidefilter(1, 1, 0, 1, 1, 1, 1, 0, 1, 1);
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
             searchparameter[6] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "STO00001" : "STO00002";
             searchparameter[7] = $('input[type=radio][name=format]:checked').val() == "PDF" ? "PDF" : "EXCEL";
             return searchparameter;
         }
         var reportprint = function () {
             getreport('StockStatusReport.aspx/Store_Get_StockStatus');

             //  url: "../../Design/Store/Services/CommonService.asmx/BindItems",
         }
    </script>
     <div id="Pbody_box_inventory">
          <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Current Status Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
        <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />
             <%--<div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            Include Zero Stock
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <input type="checkbox" id="chkzerostock" />
                        </div></div></div></div>--%>
            </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
         <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>
     </div>
</asp:Content>

