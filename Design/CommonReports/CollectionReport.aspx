<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CollectionReport.aspx.cs" Inherits="Design_OPD_CollectionReport" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript">
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnPreview').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnPreview').removeAttr('disabled');
                    }
                }
            });

        }
        function validate() {
            if ($("#<%=cblColType.ClientID%> input[type=checkbox]:checked").length == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Type');
                return false;
            }
            if ($("#<%=cblUser.ClientID%> input[type=checkbox]:checked").length == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Employee');
                return false;
            }
        }
        $(function () {
            $("[id*=chkuser]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=cblUser] input").attr("checked", "checked");
                } else {
                    $("[id*=cblUser] input").removeAttr("checked");
                }
            });

            $("[id*=cblUser] input").bind("click", function () {
                if ($("[id*=cblUser] input:checked").length == $("[id*=cblUser] input").length) {
                    $("[id*=cblUser]").attr("checked", "checked");
                } else {
                    $("[id*=chkuser]").removeAttr("checked");
                }
            });
            $("[id*=chkdep]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=cblColType] input").attr("checked", "checked");
                } else {
                    $("[id*=cblColType] input").removeAttr("checked");
                }
            });
            $("[id*=cblColType] input").bind("click", function () {
                if ($("[id*=cblColType] input:checked").length == $("[id*=cblColType] input").length) {
                    $("[id*=cblColType]").attr("checked", "checked");
                } else {
                    $("[id*=chkdep]").removeAttr("checked");
                }
            });

            $("[id*=chkAllDoctor]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chkDoctor] input").attr("checked", "checked");
                } else {
                    $("[id*=chkDoctor] input").removeAttr("checked");
                }
            });
            $("[id*=chkDoctor] input").bind("click", function () {
                if ($("[id*=chkDoctor] input:checked").length == $("[id*=chkDoctor] input").length) {
                    $("[id*=chkAllDoctor]").attr("checked", "checked");
                } else {
                    $("[id*=chkAllDoctor]").removeAttr("checked");
                }
            });

            $("[id*=chkAllSpeciality]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chkSpeciality] input").attr("checked", "checked");
                } else {
                    $("[id*=chkSpeciality] input").removeAttr("checked");
                }
            });

            $("[id*=chkSpeciality] input").bind("click", function () {
                if ($("[id*=chkSpeciality] input:checked").length == $("[id*=chkSpeciality] input").length) {
                    $("[id*=chkAllSpeciality]").attr("checked", "checked");
                } else {
                    $("[id*=chkAllSpeciality]").removeAttr("checked");
                }
            });

            $("[id*=rbtReportType] input").bind("click", function () {
                BindDoctorOrSpeciality();
            });
        });

        function BindDoctorOrSpeciality() {
            if ($("[id*=rbtReportType] input:checked").val() == "9")
                $("#trDoctor,#trDoctorSearch").show();
            else
                $("#trDoctor,#trDoctorSearch").hide();

            if ($("[id*=rbtReportType] input:checked").val() == "10")
                $("#trSpeciality,#trSpecialitySearch").show();
            else
                $("#trSpeciality,#trSpecialitySearch").hide();
        }
        $(function () {
            checkAllCentre();
            BindDoctorOrSpeciality();
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
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Collection Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div>
                <table border="0" style="width: 100%">
                    <tr style="border: dotted">
                        <td style="width: 14%; text-align: right; border: groove" valign="middle">
                            <asp:CheckBox ID="chkdep" runat="server" AutoPostBack="false" Text="Type :&nbsp;"
                                CssClass="ItDoseCheckbox" Checked="true" />
                        </td>

                        <td colspan="4" style="width: 17%; border: groove; border-left: none; overflow-y: scroll">

                            <asp:CheckBoxList ID="cblColType" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist"
                                RepeatColumns="8">
                            </asp:CheckBoxList>

                        </td>
                    </tr>
                    <tr>
                        <td style="width: 12%; text-align: right">Search By Name :&nbsp;</td>
                        <td style="text-align: left;">
                            <input id="txtSearch" onkeyup="SearchCheckbox(this,cblUser)" style="width: 300px" /></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="width: 12%; text-align: right; border: groove;">
                            <asp:CheckBox ID="chkuser" runat="server" AutoPostBack="false" Text="User :&nbsp;" Checked="true"
                                CssClass="ItDoseCheckbox" />
                        </td>
                        <td colspan="4" style="width: 17%; height: 25%; border-bottom: groove; border-right: groove; border-top: groove;">
                            <div class="scrollankur" style="text-align: left;height:200px;overflow:scroll">
                                <asp:CheckBoxList ID="cblUser" CssClass="ItDoseCheckbox" Font-Size="8" runat="server" ClientIDMode="Static"
                                    RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="7" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 12%; text-align: right; border-right: groove; border-left: groove">From Date :&nbsp;
                        </td>
                        <td>
                            <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="170px" onchange="ChkDate();"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ucFromDate_CalendarExtender" runat="server" TargetControlID="ucFromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                            &nbsp;Time :&nbsp;
                            <asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                TabIndex="2" />
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtFromTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </td>
                        <td style="width: 12%; text-align: right">To Date :&nbsp;
                        </td>
                        <td colspan="2" style="width: 12%; border-right: groove; text-align: left">
                            <table style="width: 100%; border-collapse: collapse">
                                <tr>
                                    <td>
                                        <asp:TextBox ID="ucToDate" runat="server" ToolTip="Click To Select To Date" Width="170px" onchange="ChkDate();"
                                            TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                                        <cc1:CalendarExtender ID="ucToDate_CalendarExtender" runat="server" TargetControlID="ucToDate"
                                            Format="dd-MMM-yyyy" ClearTime="true">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td>Time&nbsp;:&nbsp;
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                            TabIndex="4" />
                                        <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                            TargetControlID="txtToTime" AcceptAMPM="true">
                                        </cc1:MaskedEditExtender>
                                        <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                    </td>
                                    <td style="width: 40%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 12%; text-align: right; border-right: groove; border-left: groove; border-bottom: groove">&nbsp;</td>
                        <td style="text-align: left; border-bottom: groove">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em></td>
                        <td colspan="3" style="text-align: right; border-right: groove; border-bottom: groove">&nbsp;   <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em></td>
                    </tr>
                    <tr>
                        <td style="width: 12%; text-align: right; border-left: groove; border-right: groove; border-bottom: groove">Batch Number :&nbsp;</td>
                        <td colspan="4" style="text-align: left; border-right: groove; border-bottom: groove;">
                            <asp:TextBox ID="txtBatchnum" runat="server" Width="200px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 12%; text-align: right; border-left: groove; border-right: groove; border-bottom: groove">Report Type :&nbsp;
                        </td>
                        <td colspan="4" style="border-right: groove; border-bottom: groove">
                            <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal"
                                ToolTip="Select Report Type" RepeatColumns="5" ClientIDMode="Static">
                              
                               <%-- <asp:ListItem Value="8">Collection PaymentMode Wise(Exel)</asp:ListItem>--%>
                                <asp:ListItem Selected="True" Value="0" onclick="HideShowReportType(0)">Summarised</asp:ListItem>
                                <asp:ListItem Value="1" onclick="HideShowReportType(1)">Detailed</asp:ListItem>
                                <asp:ListItem Value="2" onclick="HideShowReportType(0)">Summarised Date Wise</asp:ListItem>
                                <asp:ListItem Value="3" onclick="HideShowReportType(0)">Summarised Department Wise</asp:ListItem>
                                <asp:ListItem Value="4" onclick="HideShowReportType(0)">IPD Collection</asp:ListItem>
                               <asp:ListItem  Value="5" onclick="HideShowReportType(0)">Collection PaymentMode wise</asp:ListItem>
                                <%--<asp:ListItem Value="6">Collection(TOTAL)</asp:ListItem>
                                <asp:ListItem Value="9" onclick="HideShowReportType(0)">Doctor Wise</asp:ListItem>
                                <asp:ListItem Value="10" onclick="HideShowReportType(0)">Speciality Wise</asp:ListItem>--%>
                                <asp:ListItem Value="11" onclick="HideShowReportType(0)">Summarised Total</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr id="trDoctorSearch" >
                        <td style="width: 12%; text-align: right">Search By Doctor :&nbsp;</td>
                        <td style="text-align: left;">
                            <input id="txtSearchDoctor" onkeyup="SearchCheckbox(this,chkDoctor)" style="width: 300px" /></td>
                        <td></td>
                    </tr>
                    <tr id="trDoctor" style="border: dotted">
                        <td style="width: 12%; text-align: right; border: groove" valign="middle">
                            <asp:CheckBox ID="chkAllDoctor" runat="server" AutoPostBack="false" Text="Dotor :&nbsp;"
                                CssClass="ItDoseCheckbox" Checked="true" />
                        </td>
                        <td colspan="4" style="width: 17%; border: groove; border-left: none;">
                            <div style="overflow-y: scroll; height: 200px;">
                                <asp:CheckBoxList ID="chkDoctor" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist"
                                    RepeatColumns="6">
                                </asp:CheckBoxList>
                            </div>
                        </td>
                    </tr>
                    <tr id="trSpecialitySearch" >
                        <td style="width: 14%; text-align: right">Search By Speciality :&nbsp;</td>
                        <td style="text-align: left;">
                            <input id="Text1" onkeyup="SearchCheckbox(this,chkSpeciality)" style="width: 300px" /></td>
                        <td></td>
                    </tr>
                    <tr id="trSpeciality" style="border: dotted">
                        <td style="width: 12%; text-align: right; border: groove" valign="middle">
                            <asp:CheckBox ID="chkAllSpeciality" runat="server" AutoPostBack="false" Text="Speciality :&nbsp;"
                                CssClass="ItDoseCheckbox" Checked="true" />
                        </td>
                        <td colspan="4" style="width: 17%; border: groove; border-left: none;">
                            <div style="overflow-y: scroll; height: 200px;">
                                <asp:CheckBoxList ID="chkSpeciality" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseCheckboxlist"
                                    RepeatColumns="6">
                                </asp:CheckBoxList>
                            </div>
                        </td>
                    </tr>
                    <tr style="border: dotted">
                        <td style="width: 12%; text-align: right; border: groove" valign="middle">
                            <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" Checked="true" /></td>
                        <td colspan="4" style="width: 17%; border: groove; border-left: none; overflow-y: scroll">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </td>
                    </tr>
                     <tr style="border: dotted;display:none;">
                        <td style="width: 12%; text-align: right; border: groove" valign="middle">
                          Report Type : </td>
                        <td colspan="4" style="width: 17%; border: groove; border-left: none; overflow-y: scroll">
                          <asp:RadioButtonList ID="rdbReportType" runat="server" RepeatDirection="Horizontal">
                              <asp:ListItem Value="PDF" Selected="True">PDF</asp:ListItem>
                              <asp:ListItem Value="EXCEL">EXCEL</asp:ListItem>
                          </asp:RadioButtonList>
                        </td>
                        
                    </tr>

                     <tr style="border: dotted;" id="trreportType">
                        <td style="width: 12%; text-align: right; border: groove" valign="middle">
                          Report Type : </td>
                        <td colspan="4" style="width: 17%; border: groove; border-left: none; overflow-y: scroll">
                          <asp:RadioButtonList ID="rdbDetailReportType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                              <asp:ListItem Value="PDF" Selected="True">PDF</asp:ListItem>
                              <asp:ListItem Value="EXCEL">EXCEL</asp:ListItem>
                          </asp:RadioButtonList>
                        </td>
                        
                    </tr>

                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnPreview" runat="server" Text="Report" CssClass="ItDoseButton"
                OnClick="btnPreview_Click" ClientIDMode="Static" ToolTip="Click To Open Report"
                TabIndex="5" OnClientClick="return validate()" />&nbsp;&nbsp;
         
        </div>
    </div>
    <script type="text/javascript">
        // A $( document ).ready() block.
        $(document).ready(function () {
            var checked_radio = $("[id*=rbtReportType] input:checked");
            var value = checked_radio.val();

            HideShowReportType(value);
        });

        function HideShowReportType(Typ) {

            if (Typ==1) {
                $("#rdbDetailReportType").show();
                $("#trreportType").show();
                
            } else {
                $("#rdbDetailReportType").hide();
                $("#trreportType").hide();
            }
        }

    </script>

</asp:Content>
