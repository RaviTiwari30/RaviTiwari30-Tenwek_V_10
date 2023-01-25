<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BioMedicalWasteReport.aspx.cs" Inherits="Design_Biomedicalwaste_BioMedicalWasteReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <script type="text/javascript">
        $(document).ready(function () {
            ShowHideDiv();
            BindDepartment(function () {
                BindDispatchedTo(function () {
                });
            });
        });
        function ShowHideDiv() {
            var chkValue = $('input[type=radio][name=rdoactive]:checked').val();
            if (chkValue == "1") {
                $('#divhospitaldispatch').css('display', 'none');
                $('#divdepartmentdispatch').css('display', '');
            }
            else {
                $('#divdepartmentdispatch').css('display', 'none');
                $('#divhospitaldispatch').css('display', '');
            }
        }
        var BindDepartment = function (callback) {
            $ddlDepartment = $('#ddlDepartment');
            serverCall('Services/BioMedicalwaste.asmx/BindRoleMaster', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'RoleName', isSearchAble: true });
                callback($ddlDepartment.val());
            });
        }
        var BindDispatchedTo = function (callback) {
            $ddlDispatchTo = $('#ddlDispatchTo');
            serverCall('Services/BioMedicalwaste.asmx/GetDispatch', {}, function (response) {
                $ddlDispatchTo.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'Id', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlDispatchTo.val());
            });
        }
        function SearchDataForReport() {
            debugger;
            var centreIDs = "";
            $('#chkCentre tr').find('input[type=checkbox]:checked').each(function () {
                if (centreIDs == "")
                    centreIDs = $(this).val();
                else
                    centreIDs = centreIDs + "," + $(this).val();
            });

            if (centreIDs == "") {
                modelAlert('Please Select Centre..');
                return false;
           
            }
            var data = {
                FromDate: $('#txtFromDate').val(),
                ToDate: $('[id$=txtToDate]').val(),
                DepartmentId: $('#ddlDepartment').val(),
                Type: $('input[type=radio][name=rdoactive]:checked').val(),
                deptstatus: $('#ddlStatus').val(),

                hospstatus: $('#ddlHospstatus').val(),
                dispatchedto: $('[id$=ddlDispatchTo]').val(),
                centreIDs: centreIDs,
                  
            }
            serverCall('Services/BioMedicalwaste.asmx/BindBioMedicalWasteReport', data, function (response) {
                debugger;
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    window.open(responseData.responseURL);
                }
                else
                    modelAlert(responseData.response);

            });
        }
        function bindBioMedicallReport(data) {
            ;
            $('#tblReport tbody').empty();

            var row = '';
            for (var i = 0; i < data.length; i++) {

                var j = $('#tblReport tbody tr').length + 1;
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DATE + '</td>';
                row += '<td id="tdTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TIME + '</td>';
                //row += '<td id="tdTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Quantity + '</td>';
                row += '<td id="tdBagame" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BagName + '</td>';

                row += '<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Quantity + '</td>';
                row += '<td id="tdWeight" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Weight + '</td>';
                row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Id + '</td>';
                row += '<td id="tddispatchedById" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].dispatchedById + '</td>';
                row += '<td id="tdwt" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].wt + '</td>';
                row += '<td id="tdunit" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ut + '</td>';
                row += '<td id="tdBagId" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BagId + '</td>';
                row += '</tr>';

                $('#tblReport tbody').append(row);
            }
        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

             if (status == true) {
                 $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
             }
             else {
                 $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
             }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                 $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Bio Medical Waste Report</b>
            <span style="display: none" id="spnBagID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" id="divimageBind">
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9">
                            <input type="radio" name="rdoactive" onclick="ShowHideDiv()" value="1" checked="checked" />Dept Dispatch
                         <%--   <input type="radio" name="rdoactive" onclick="ShowHideDiv()" value="2" />Dept Recieve--%>
                            <input type="radio" name="rdoactive" onclick="ShowHideDiv()" value="2" />Hospital Dispatch
                        </div>


                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" AutoComplete="off" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="calPurDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" AutoComplete="off" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDepartment" class="requiredField" data-title="Select Dispatch"></select>

                        </div>

                    </div>
                    <div class="row" id="divdepartmentdispatch" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus">
                            
                      
                                 <option value="1">Pending</option>
                                <option value="2">Recieved</option>
                                <option value="3">Rejected</option>
                            </select>
                        </div>
                    </div>
                    <div class="row" id="divhospitaldispatch" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlHospstatus">
                                <option value="1">Pending</option>
                                <option value="2">Rejected</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Dispatch To</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDispatchTo" class="requiredField" data-title="Select Dispatch"></select>

                        </div>
                    </div>
                      <div class="row">
                       <div class="col-md-3">
                           <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" Checked="true" />
                       </div>
                       <div class="col-md-12">
                           <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                       </div>
                   </div>
                    <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">                     
                        <div class="col-md-24" style="text-align:center;">                         
                            <%-- <input type="button" id="btnView" class="ItDoseButton" onclick="ViewDetails(this)" value="View" />
         <input type="button"id="btnPrint" onclick="ViewDetails(this)"  class="ItDoseButton" value="Print" />
          <asp:CheckBox ID="ChkExport" runat="server" ClientIDMode="Static" Text="Export"/> --%>
                            <asp:Button ID="btnView1" runat="server" Visible="false" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                </div>

                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnsearch" value="Report" onclick="return SearchDataForReport();" />
            </div>
        </div>
        <%--<div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Biomedical Department Dispatch Details
            </div>
            <%--<div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromdate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                    </asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtFromdate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txttodate" CssClass="requiredField" runat="server" Style="width: 100%;" TabIndex="3" ClientIDMode="Static">
                    </asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txttodate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>

                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                    <input type="button" id="btnSearch" value="Search" onclick="return SearchData();" />

                </div>
            </div>--%>
            <%--<div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblReport" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Date</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Time</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Bag Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Quantity</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Weight</th>


                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>--%>
        </div>--%>

    </div>
</asp:Content>

