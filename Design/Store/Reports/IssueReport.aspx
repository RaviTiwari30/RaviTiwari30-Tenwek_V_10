<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="IssueReport.aspx.cs" Inherits="Design_Store_IssueReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {
            showhidefilter(1, 1, 0, 1, 1, 1, 1, 1, 0);
            //showhidefilter(center, department, supplier, category, subcategory, item, fromdate, todate,reportype);
            $('#ddlIssueType').on('change', function () {
                if ($(this).val() == "P") {
                    $('.patient').attr('disabled', 'disabled');
                    $('#ddlPatientType').val('A');
                    $('#txtpatientid').val('');
                }
                else {
                    $('.patient').removeAttr('disabled');
                    $('#ddlPatientType').val('A');
                    $('#txtpatientid').val('');
                }
            });
          //  $bindtoDepartment(function () { });
        });
        
        $bindtoDepartment = function (callBack) {
              serverCall('IssueReport.aspx/BindDepartment', {}, function (response) {
                  if (response != "") {
                      var $lsttodepartment = $('#lsttodepartment');
                      $lsttodepartment.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
                  }
                  else {
                      modelAlert('No Record Found');
                  }
                  callBack(true);
              });
        }
        function getsearchparameter() {
            if (Getmultiselectvalue($('#lstcenter')) == '')
                return [{ erroMessage: 'Please Select Center', type: 'V' }]; 
            if (Getmultiselectvalue($('#lstdepartment')) == '')
                return [{ erroMessage: 'Please Select Department', type: 'V' }];
            if (Getmultiselectvalue($('#lsttodepartment')) == "''")
                return [{ erroMessage: 'Please Select To Department',type:'V' }];

            var searchparameter = new Array();
            searchparameter[0] = Getmultiselectvalue($('#lstcenter'));
            searchparameter[1] = Getmultiselectvalue($('#lstdepartment'));
            searchparameter[2] = Getmultiselectvalue($('#lstCategory'));
            searchparameter[3] = Getmultiselectvalue($('#lstsubgroup'));
            searchparameter[4] = Getmultiselectvalue($('#lstitems'));
            searchparameter[5] = Getmultiselectvalue($('#lsttodepartment'));;
            searchparameter[6] = $('#ddlReportType').val();
            searchparameter[7] = $('#ddlIssueType').val();
            searchparameter[8] = $('#ddlTransactionType').val();
            searchparameter[9] = $('#ddlPatientType').val();
            searchparameter[10] = $('#txtpatientid').val();
            searchparameter[11] = $('#txtdatefrom').val();
            searchparameter[12] = $('#txtdateTo').val();

            return searchparameter;
        }
        var reportprint = function () {
            getreport('IssueReport.aspx/Store_Get_IssueDetail');
        }

    </script>
<script src="../../Scripts/Message.js" type="text/javascript" ></script>
<cc1:toolkitscriptmanager ID="ToolkitScriptManager1" EnablePageMethods="true" 
        runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:toolkitscriptmanager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Stock Issue Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
         <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />
         <div class="row">
                <div class="col-md-24">
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">Issued To</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <asp:ListBox ID="lsttodepartment" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" ></asp:ListBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <select id="ddlReportType">
                               <option value="D">Detailed</option>
                               <option value="S">Summary</option>
                           </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Issue Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <select id="ddlIssueType">
                             <option value="B">ALL</option>
                             <option value="P">Patient</option>
                             <option value="D">Department</option>
                             <option value="S">Out Supplier</option>
                         </select>
                        </div></div>
                        <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">Transaction Type</label>
                            <b class="pull-right">:</b>
                        </div>
                            <div class="col-md-5">
                               <select id="ddlTransactionType">
                                   <option value="B">Both</option>
                                   <option value="I">Issue</option>
                                   <option value="R">Return</option>
                               </select>
                            </div>
                            <div class="col-md-3">
                            <label class="pull-left">Patient Type</label>
                            <b class="pull-right">:</b>
                        </div>
                            <div class="col-md-5">
                                <select id="ddlPatientType" class="patient">
                                    <option value="A">ALL</option>
                                    <option value="O">OPD</option>
                                    <option value="I">IPD</option>
                                    <option value="W">Walkin</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                            <div class="col-md-5">
                                <input type="text" id="txtpatientid" class="patient" />
                            </div>
                        </div>
                    </div></div></div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
         <input type="button" id="btnsearch" onclick="reportprint()" value="Report"/>
        </div>
    </div>
</asp:Content>
