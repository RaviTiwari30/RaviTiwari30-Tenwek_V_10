<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchStockAdjustment.aspx.cs" Inherits="Design_Finance_SearchStockAdjustment" MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript">
        $(function () {
            showhidefilter(1, 1, 0, 1, 1, 1, 1, 1, 1, 1);
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
            searchparameter[7] = $("#<%=rdbStockType.ClientID%> input[type=radio]:checked").val();
            searchparameter[8] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "M" : "G";
            searchparameter[9] = $('input[type=radio][name=format]:checked').val() == "PDF" ? "PDF" : "EXCEL";;
            return searchparameter;
        }
          var reportprint = function () {
              getreport('SearchStockAdjustment.aspx/Store_Get_AdjustmentDetail');
          }
    </script>
    <div id="Pbody_box_inventory">
         <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
                    EnableScriptGlobalization="true" EnableScriptLocalization="true">
                </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Stock Adjustment / Processing Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
              <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Stock Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                           <asp:RadioButtonList ID="rdbStockType" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                               <asp:ListItem Value="A" Selected="True">Adjustment(+)</asp:ListItem>
                               <asp:ListItem Value="P">Process(-)</asp:ListItem>
                           </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
               <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>
    </div>
</asp:Content>
