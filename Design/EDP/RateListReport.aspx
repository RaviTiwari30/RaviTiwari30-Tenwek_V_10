<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RateListReport.aspx.cs" Inherits="EDP_RateListReport"
    MasterPageFile="~/DefaultHome.master" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" language="javascript">

        $(function () {
            $("[id*=chkAll]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chkDepartment] input").attr("checked", "checked");
                } else {
                    $("[id*=chkDepartment] input").removeAttr("checked");
                }
            });
            $("[id*=chkDepartment] input").bind("click", function () {
                if ($("[id*=chkDepartment] input:checked").length == $("[id*=chkDepartment] input").length) {
                    $("[id*=chkAll]").attr("checked", "checked");
                } else {
                    $("[id*=chkAll]").removeAttr("checked");
                }
            });
            $("[id*=ChkAllRoomType]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chkCaseType] input").attr("checked", "checked");
                } else {
                    $("[id*=chkCaseType] input").removeAttr("checked");
                }
            });
            $("[id*=chkDepartment] input").bind("click", function () {
                if ($("[id*=chkCaseType] input:checked").length == $("[id*=chkCaseType] input").length) {
                    $("[id*=ChkAllRoomType]").attr("checked", "checked");
                } else {
                    $("[id*=ChkAllRoomType]").removeAttr("checked");
                }
            });
        });

        function Dept() {
          //  if ($("[id*=chkCentre] input:checked").length == "0") {
          //      $("#<%=lblMsg.ClientID%>").text('Please Select Centre');
         //           return false;
         //       }
            if ($("[id*=chkDepartment] input:checked").length == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Department');
                return false;
            }
            if ($("[id*=rbtnType] input:checked").next().text() != "OPD") {
                if ($("[id*=chkCaseType] input:checked").length == "0") {
                    $("#<%=lblMsg.ClientID%>").text('Please Select RoomType');
                    return false;
                }
            }
        
        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", false);
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
            <b>Rate List Report&nbsp;</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rbtnType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rbtnType_SelectedIndexChanged"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">OPD</asp:ListItem>
                                <asp:ListItem>IPD</asp:ListItem>
                                <asp:ListItem>All</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" AutoPostBack="True"
                                TabIndex="1" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="True"
                                TabIndex="2" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblSchedule" runat="server" Text="Schedule Charges"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlScheduleCharges" runat="server"
                                TabIndex="3">
                            </asp:DropDownList>
                        </div>
                    </div>
                     <div class="row" style="display:none">
                        <div class="col-md-3" >
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" Checked="true" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                            </div>
                         </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre" AutoPostBack="true" OnSelectedIndexChanged="ddlCentre_SelectedIndexChanged" >
                            </asp:DropDownList>

                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table style="width: 100%">
                <tr>
                    <td style="width: 12%; text-align: left; border: groove">
                        <asp:CheckBox ID="chkAll" Text="Departments :&nbsp;" runat="Server" AutoPostBack="false" OnCheckedChanged="chkAll_CheckedChanged" />
                    </td>
                    <td style="width: 100%; text-align: left; border: groove">
                        <div style="overflow: scroll; height: 170px; text-align: left;">
                            <asp:CheckBoxList ID="chkDepartment" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table style="width: 100%">
                <tr>
                    <td style="width: 12%; text-align: left;border: groove">
                        <asp:Label ID="lblCaseType" runat="server" Text=""></asp:Label>
                        <asp:CheckBox ID="ChkAllRoomType" Text="Room Type" runat="Server" AutoPostBack="false"
                            OnCheckedChanged="ChkAllRoomType_CheckedChanged" />
                    </td>
                    <td style="width: 100%; text-align: left; border: groove">
                        <asp:CheckBoxList ID="chkCaseType" runat="server" RepeatColumns="4" RepeatDirection="Horizontal">
                        </asp:CheckBoxList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            &nbsp;<asp:Button ID="btnSearch" runat="server" Text="Report" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" OnClientClick="return Dept()" />
        </div>
    </div>
</asp:Content>
