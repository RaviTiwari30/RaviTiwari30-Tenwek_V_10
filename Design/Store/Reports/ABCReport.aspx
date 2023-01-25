<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="ABCReport.aspx.cs" Inherits="Design_Store_ABCReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(function () {
            showhidefilter(1, 1, 0, 1, 1, 1, 0, 0, 1, 1);
            //showhidefilter(center, department, supplier, category, subcategory, item, fromdate, todate,reportype,storetype);
        });
        function getsearchparameter() {
            if (Getmultiselectvalue($('#lstcenter')) == '')
                return [{ erroMessage: 'Please Select Center', type: 'V' }];
            if (Getmultiselectvalue($('#lstdepartment')) == '')
                return [{ erroMessage: 'Please Select Department', type: 'V' }];
            if ($('#txtACategoryPer').val() > $('#txtBCategoryPer').val())
                return [{ erroMessage: 'Please Enter the Value Less Than B Category', type: 'V' }];
            if ($('#txtACategoryPer').val() > $('#txtCCategoryPer').val())
                return [{ erroMessage: 'Please Enter the Value Less Than C Category', type: 'V' }];
            if ($('#txtBCategoryPer').val() > $('#txtCCategoryPer').val())
                return [{ erroMessage: 'Please Enter the Value Less Than C Category', type: 'V' }];
            if ($('#txtCCategoryPer').val() < $('#txtBCategoryPer').val())
                return [{ erroMessage: 'Please Enter the Value Greater Than B Category', type: 'V' }];
            if ($('#txtCCategoryPer').val() < $('#txtACategoryPer').val())
                return [{ erroMessage: 'Please Enter the Value Greater Than A Category', type: 'V' }];
            var searchparameter = new Array();
            searchparameter[0] = Getmultiselectvalue($('#lstcenter'));
            searchparameter[1] = Getmultiselectvalue($('#lstdepartment'));
            searchparameter[2] = Getmultiselectvalue($('#lstCategory'));
            searchparameter[3] = Getmultiselectvalue($('#lstsubgroup'));
            searchparameter[4] = Getmultiselectvalue($('#lstitems'));
            searchparameter[5] = $('input[type=radio][name=storetype]:checked').val() == "STO00001" ? "STO00001" : "STO00002";
            searchparameter[6] = $('#txtACategoryPer').val();
            searchparameter[7] = $('#txtBCategoryPer').val();
            searchparameter[8] = $('#txtCCategoryPer').val();
            searchparameter[9] = $('input[type=radio][name=format]:checked').val() == "PDF" ? "PDF" : "EXCEL";
            return searchparameter;
        }
          var reportprint = function () {
              getreport('../../../Design/Store/Reports/ABCReport.aspx/Store_Get_ABCData');
          }
    </script>
    <div id="Pbody_box_inventory">
         <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>ABC Analysis Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
       <div class="POuter_Box_Inventory">
        <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />
      <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            A Category(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <input type="text" value="70" data-title="Less Than And Equal 70 Per" onlynumber="3"    autocomplete="off"  max-value="100"  id="txtACategoryPer" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            B Category(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <input type="text" value="80" data-title="Greater Than 70 And Less Than And Equal 80 Per" onlynumber="3"    autocomplete="off"  max-value="100" id="txtBCategoryPer" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            C Category(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <input type="text" value="81" data-title="Greater Than 80 Per"  onlynumber="3"    autocomplete="off"  max-value="100" id="txtCCategoryPer" />
                        </div>
                    </div></div></div></div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
         <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>
      
    </div>
</asp:Content>
