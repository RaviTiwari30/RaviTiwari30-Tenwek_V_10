<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LabourChart.aspx.cs" Inherits="Design_IPD_LabourChart" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">
        function note() {
            if ($.trim($("#<%=ddlTypeOfFluid.ClientID%>").val()) == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Kind of Fluid');
                $("#<%=ddlTypeOfFluid.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=ddlTypeOfFluid.ClientID%>").val()) != "0" && ($("#<%=txtAmount.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Amount Of Fluid');
                $("#<%=txtAmount.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtUrineTime.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Urine Time');
                $("#<%=txtUrineTime.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtUrineAmount.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Amount Of Urine');
                $("#<%=txtUrineAmount.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtContractionTime.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Contraction Time');
                $("#<%=txtContractionTime.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtDurationtime.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Duration Time');
                $("#<%=txtDurationtime.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtFH.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter FH Value');
                $("#<%=txtFH.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtIntervalTime.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Interval Time');
                $("#<%=txtIntervalTime.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtResp.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Resp value');
                $("#<%=txtResp.ClientID%>").focus();
                return false;
            }
            if ($.trim($("#<%=txtBP.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter BP Value');
                $("#<%=txtBP.ClientID%>").focus();
                return false;
            }
        }

        $(function () {
            $("#txtAmount").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    $("#lblErrorMsg1").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });
            $("#txtUrineAmount").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    $("#lblErrorMsg2").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });
            $("#txtFH").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    $("#lblErrorMsg3").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });
            $("#txtResp").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    $("#lblErrorMsg4").html("Digits Only").show().fadeOut("slow");
                    return false;
                }
            });
        });
    </script>

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="sc" runat="server"></asp:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Labour Ward Form </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                <asp:Label ID="lblID" runat="server" Visible="false" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row" style="height: 36px;">
                    <div class="col-md-3">
                        <label class="pull-left">Date</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtDate" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Click To Select Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Time</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtTime" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Time"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="meeTime" runat="server" TargetControlID="txtTime" Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                        <cc1:MaskedEditValidator ID="mevTime" runat="server" ControlToValidate="txtTime" ControlExtender="meeTime" IsValidEmpty="true" EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Kind of Fluid</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlTypeOfFluid" class="requiredField" runat="server" ToolTip="Select Kind of Fluid">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">Normal Saline</asp:ListItem>
                            <asp:ListItem Value="2">Ringer Lactate</asp:ListItem>
                            <asp:ListItem Value="3">Dextrose Saline</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="row" style="height: 36px;">
                    <div class="col-md-3">
                        <label class="pull-left">Amt. Of Fluid</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtAmount" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Amount Of Fluid" Width="70%"></asp:TextBox><b class="pull-right">ml</b>
                        <br />
                        <asp:Label ID="lblErrorMsg1" runat="server" ForeColor="Red"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Urine Time</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtUrineTime" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Urine Time"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="meeUrineTime" runat="server" TargetControlID="txtUrineTime" Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                        <cc1:MaskedEditValidator ID="mevUrineTime" runat="server" ControlToValidate="txtUrineTime" ControlExtender="meeUrineTime" IsValidEmpty="true" EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time" ForeColor="Red"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Amt. Of Urine</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtUrineAmount" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Amount Of Urine" Width="70%"></asp:TextBox><b class="pull-right">ml</b>
                        <asp:Label ID="lblErrorMsg2" runat="server" ForeColor="Red"></asp:Label>
                    </div>
                </div>
                <div class="row" style="height: 36px;">
                    <div class="col-md-3">
                        <label class="pull-left">Contraction</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtContractionTime" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Contraction Time"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="meeContractionTime" runat="server" TargetControlID="txtContractionTime" AcceptAMPM="true" Mask="99:99" MaskType="Time" />
                        <cc1:MaskedEditValidator ID="mevContractionTime" runat="server" ControlToValidate="txtContractionTime" ControlExtender="meeContractionTime" IsValidEmpty="true" EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Duration</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtDurationtime" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Duration Time"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="meeDurationtime" runat="server" TargetControlID="txtDurationtime" AcceptAMPM="true" Mask="99:99" MaskType="Time" />
                        <cc1:MaskedEditValidator ID="mevDurationtime" runat="server" ControlToValidate="txtDurationtime" ControlExtender="meeDurationtime" EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time" IsValidEmpty="true"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">F.H</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtFH" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter F.H."></asp:TextBox>
                        <asp:Label ID="lblErrorMsg3" runat="server" ForeColor="Red"></asp:Label>
                    </div>
                </div>
                <div class="row" style="height: 36px;">
                    <div class="col-md-3">
                        <label class="pull-left">Interval</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtIntervalTime" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Interval Time"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="meeIntervalTime" runat="server" AcceptAMPM="true" Mask="99:99" MaskType="Time" TargetControlID="txtIntervalTime" />
                        <cc1:MaskedEditValidator ID="mevIntervalTime" runat="server" ControlToValidate="txtIntervalTime" ControlExtender="meeIntervalTime" EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time" IsValidEmpty="true"></cc1:MaskedEditValidator>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Pulse</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtResp" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter Pulse" Width="70%"></asp:TextBox><b class="pull-right">BPM</b>
                        <asp:Label ID="lblErrorMsg4" runat="server" ForeColor="Red"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">B/P</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtBP" CssClass="requiredField ItDoseTextinputText" runat="server" ToolTip="Enter B/P" Width="70%"></asp:TextBox><b class="pull-right">mm/Hg</b>
                        <asp:Label ID="lblerrormsg6" runat="server" ForeColor="Red"></asp:Label>
                    </div>
                </div>
                <div class="row" style="height: 36px;">
                    <div class="col-md-3">
                        <label class="pull-left">LMP</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtLMP" CssClass="ItDoseTextinputText" runat="server" ToolTip="Clieck To Select Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="calLMP" runat="server" TargetControlID="txtLMP" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Comments</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <asp:TextBox ID="txtComment" CssClass="ItDoseTextinputText" runat="server" TextMode="MultiLine" Style="Height: 50px" ToolTip="Enter Comment"></asp:TextBox></td>
                    </div>
                    <div class="col-md-5">
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" OnClientClick="return note()" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="ItDoseButton" Visible="false" OnClick="btnUpdate_Click" OnClientClick="return note();" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" Visible="false" OnClick="btnCancel_Click" />
                <%--<asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" OnClick="btnPrint_Click1" />--%>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px; overflow: auto;">
                    Results
                </div>
                <div style="overflow: auto; overflow-y: auto; padding: 3px; height: 274px;">
                    <asp:GridView ID="grdNursing" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdNursing_RowDataBound" OnRowCommand="grdNursing_RowCommand" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="true">
                        <Columns>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                    <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center"/>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>
                                <ItemStyle CssClass="GridViewItemStyle" Width="20px" HorizontalAlign="Center"></ItemStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Time">
                                <ItemTemplate>
                                    <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="KindOfFluid">
                                <ItemTemplate>
                                    <asp:Label ID="lblKindOfFluid" runat="server" Text='<%#Eval("KindOfFluid") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AmtOfFluid">
                                <ItemTemplate>
                                    <asp:Label ID="lblAmtOfFluid" runat="server" Text='<%#Eval("AmtOfFluid") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="UrineTime">
                                <ItemTemplate>
                                    <asp:Label ID="lblUrineTime" runat="server" Text='<%#Eval("UrineTime") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AmtOfUrine">
                                <ItemTemplate>
                                    <asp:Label ID="lblAmtOfUrine" runat="server" Text='<%#Eval("AmtOfUrine") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Contraction">
                                <ItemTemplate>
                                    <asp:Label ID="lblContraction" runat="server" Text='<%#Eval("Contraction") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ContractionTime">
                                <ItemTemplate>
                                    <asp:Label ID="lblContractionTime" runat="server" Text='<%#Eval("ContractionTime") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Duration">
                                <ItemTemplate>
                                    <asp:Label ID="lblDuration" runat="server" Text='<%#Eval("Duration") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Interval">
                                <ItemTemplate>
                                    <asp:Label ID="lblInterval" runat="server" Text='<%#Eval("IntervalTime") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="FH">
                                <ItemTemplate>
                                    <asp:Label ID="lblFH" runat="server" Text='<%#Eval("FH") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Pulse">
                                <ItemTemplate>
                                    <asp:Label ID="lblPulse" runat="server" Text='<%#Eval("Pulse") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="B/P">
                                <ItemTemplate>
                                    <asp:Label ID="lblBP" runat="server" Text='<%#Eval("BP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="LMP">
                                <ItemTemplate>
                                    <asp:Label ID="lblLMP" runat="server" Text='<%#Eval("LMP") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remarks">
                                <ItemTemplate>
                                    <asp:Label ID="lblRemarks" runat="server" Text='<%#Eval("Remarks") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                        <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

