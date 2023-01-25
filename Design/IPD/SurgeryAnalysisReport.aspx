<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="SurgeryAnalysisReport.aspx.cs" Inherits="Design_IPD_SurgeryAnalysisReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.scroll').slimScroll({
                color: '#008AFF',
                height: '150px',
            });
            $('#txtFromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                         $('#<%=btnSearch.ClientID %>,#<%=btnItems.ClientID %>').attr('disabled', 'disabled');
                     }
                     else {
                         $('#<%=lblMsg.ClientID %>').text('');
                         $('#<%=btnSearch.ClientID %>,#<%=btnItems.ClientID %>').removeAttr('disabled');

                     }
                 }
             });

         }

    </script>
    <script type="text/javascript">
        $(function () {
            $("[id*=chkSubGroups]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlSubGroups] input").attr("checked", "checked");
                } else {
                    $("[id*=chlSubGroups] input").removeAttr("checked");
                }
            });
            $("[id*=chlSubGroups] input").bind("click", function () {
                if ($("[id*=chlSubGroups] input:checked").length == $("[id*=chlSubGroups] input").length) {
                    $("[id*=chkSubGroups]").attr("checked", "checked");
                } else {
                    $("[id*=chkSubGroups]").removeAttr("checked");
                }
            });


            $("[id*=chkItems]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlItems] input").attr("checked", "checked");
                } else {
                    $("[id*=chlItems] input").removeAttr("checked");
                }
            });
            $("[id*=chlItems] input").bind("click", function () {
                if ($("[id*=chlItems] input:checked").length == $("[id*=chlItems] input").length) {
                    $("[id*=chkItems]").attr("checked", "checked");
                } else {
                    $("[id*=chkItems]").removeAttr("checked");
                }
            });

            $("[id*=chkdoctor]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chkDoctors] input").attr("checked", "checked");
                } else {
                    $("[id*=chkDoctors] input").removeAttr("checked");
                }
            });
            $("[id*=chkDoctors] input").bind("click", function () {
                if ($("[id*=chkDoctors] input:checked").length == $("[id*=chkDoctors] input").length) {
                    $("[id*=chkdoctor]").attr("checked", "checked");
                } else {
                    $("[id*=chkdoctor]").removeAttr("checked");
                }
            });
            $("[id*=chkPanel]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlPanel] input").attr("checked", "checked");
                } else {
                    $("[id*=chlPanel] input").removeAttr("checked");
                }
            });
            $("[id*=chlItems] input").bind("click", function () {
                if ($("[id*=chlItems] input:checked").length == $("[id*=chlItems] input").length) {
                    $("[id*=chkPanel]").attr("checked", "checked");
                } else {
                    $("[id*=chkPanel]").removeAttr("checked");
                }
            });

        });

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
        <Ajax:ScriptManager ID="sm" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
                <div style="text-align: center">
                    <b>&nbsp;Surgery Analysis Report</b><br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" />
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server"  ClientIDMode="Static"/>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkIsBillDate" Text="BillDate" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Report Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal"
                                RepeatColumns="3">
                                <asp:ListItem Selected="True" Value="1" Text="Detail Report" />
                                <asp:ListItem Text="Doctor Wise Summary " Value="2" />
                                <asp:ListItem Text="Department Wise Summary" Value="3"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Additional Search Criteria
            </div>
            <table align="left" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="text-align: center; width: 10%; border: groove">
                        <asp:CheckBox ID="chkSubGroups" runat="server" Text="Departments" AutoPostBack="false"
                            OnCheckedChanged="chkSubGroups_CheckedChanged" CssClass="ItDoseCheckbox" />
                    </td>
                    <td colspan="4" style="width: 100%; border: groove">
                        <div style="text-align: left" class="scrollankur">
                            <asp:CheckBoxList ID="chlSubGroups" runat="server" RepeatColumns="6" RepeatDirection="Horizontal"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
                </table>
                    <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                              <div class="col-md-5"></div>
                            <div class="col-md-2">
                                 <asp:Button ID="btnItems" runat="server" Text="Surgery" CausesValidation="False"
                            OnClick="btnItems_Click" CssClass="ItDoseButton" />
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Search By Surgery Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-13">
                                  <input type="text" id="Text1" onkeyup="SearchCheckbox(this,'#chlItems')" style="width: 300px" />
                            </div>
                        </div>
                    </div>
                     <div class="col-md-1"></div>
                </div>
            <table align="left" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="text-align: center; width: 10%; border: groove">
                        <asp:CheckBox ID="chkItems" runat="server" Text="Surgery " AutoPostBack="false" OnCheckedChanged="chkItems_CheckedChanged"
                            CssClass="ItDoseCheckbox" />
                    </td>
                    <td colspan="4" style="width: 100%; border: groove">
                        <div class="scroll" style="text-align: left">
                            <asp:CheckBoxList ID="chlItems" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
                </table>
             <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-7">
                                
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Search By Doctor Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-13">
                                   <input type="text" id="Text2" onkeyup="SearchCheckbox(this,'#chkDoctors')" style="width: 300px" />
                            </div>
                        </div>
                    </div>
                     <div class="col-md-1"></div>
                </div>
               <table align="left" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="text-align: center; width: 10%; border: groove">
                        <asp:CheckBox ID="chkdoctor" runat="server" Text="Doctors" CssClass="ItDoseCheckbox" />
                    </td>
                    <td colspan="4" style="width: 100%; text-align: left; border: groove">
                        <div class="scroll" style="text-align: left">
                            <asp:CheckBoxList ID="chkDoctors" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
                </table>
            <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-7">
                                
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left">Search By Panel Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-13">
                                 <input type="text" id="Text3" onkeyup="SearchCheckbox(this,'#chlPanel')" style="width: 300px" />
                            </div>
                        </div>
                    </div>
                     <div class="col-md-1"></div>
                </div>
                  <table align="left" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr id="tr_Panellist" runat="server">
                    <td style="text-align: center; width: 10%; border: groove">
                        <asp:CheckBox ID="chkPanel" runat="server" Text="Panels" CssClass="ItDoseCheckbox" />
                    </td>
                    <td colspan="4" style="width: 100%; border: groove">
                        <div style="text-align: left;" class="scroll">
                            <asp:CheckBoxList ID="chlPanel" runat="server" RepeatColumns="5" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton"
                OnClick="btnSearch_Click" />
        </div>
    </div>
</asp:Content>
