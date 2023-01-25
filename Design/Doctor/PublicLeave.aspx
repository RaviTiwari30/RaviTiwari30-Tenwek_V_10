<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PublicLeave.aspx.cs" Inherits="Design_Payroll_PublicLeave" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(function () {
            $('#txtDate').change(function () {

                ChkDate();
            });
            $('#txtdateto').change(function () {

                ChkDate();
            });
        });


        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtDate').val() + '",DateTo:"' + $('#txtdateto').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {

                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSave.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=btnUpdate.ClientID %>').prop('disabled', 'disabled');


                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSave.ClientID %>').removeProp('disabled', 'disabled');
                        $('#<%=btnUpdate.ClientID %>').removeProp('disabled', 'disabled');



                    }
                }
            });

        }
    </script>
    <script type="text/javascript">
        function validatespace() {
            var card = $('#<%=txtReason.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.') {
                $('#<%=txtReason.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblMsg.ClientID %>').text('');
                return true;
            }

        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera
            else if (e.which) {
                keynum = e.which
            }

            keychar = String.fromCharCode(keynum)
            var card = $('#<%=txtReason.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtReason.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == "." || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
       <%-- <Ajax:UpdatePanel ID="up" runat="server">
            <ContentTemplate>--%>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>Doctor Leave</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddldoclist" runat="server" Style="text-align: left" TabIndex="1" AutoPostBack="true" OnSelectedIndexChanged="ddldoclist_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Reason
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">

                            <asp:TextBox ID="txtReason" runat="server" TabIndex="2"
                                ToolTip="Enter Holiday Name" AutoCompleteType="Disabled" CssClass="requiredField" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date  
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" AutoCompleteType="Disabled" runat="server" ToolTip="Select Date" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" ToolTip="Select To Date" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="caltodate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtnActive" runat="server" TabIndex="3" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1">On Leave</asp:ListItem>
                                <asp:ListItem Value="0">Revert Leave</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Time  
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:TextBox ID="txtfromtime" AutoCompleteType="Disabled" runat="server" ToolTip="Select Date" ClientIDMode="Static" TabIndex="6"></asp:TextBox>
                           <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtfromtime" AcceptAMPM="True">
                            </cc1:MaskedEditExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txttotime" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" ToolTip="Select Time" TabIndex="7"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txttotime" AcceptAMPM="True">
                            </cc1:MaskedEditExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <asp:Button ID="btnUpdate" runat="server" Text="Update" Style="padding-top: 5px;" CssClass="ItDoseButton save" Visible="false" OnClick="btnUpdate_Click1" ValidationGroup="a" TabIndex="9" ToolTip="Click to Update" />
                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSaveRecord_Click" Style="padding-top: 5px;" CssClass="ItDoseButton save" ValidationGroup="a" TabIndex="8" ToolTip="Click to Save" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" Visible="False" Style="padding-top: 5px;" CssClass="ItDoseButton save" OnClick="btnCancel_Click" ToolTip="Click to Cancel" TabIndex="10" />
                </div>
                <div id="divList" runat="server" class="POuter_Box_Inventory" visible="false">
                    <div class="Purchaseheader">
                        Leave List
                    </div>
                    <div class="row" style="max-height: 200px; overflow: auto;">
                        <div class="col-md-24">
                            <asp:GridView ID="grdLeave" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnSelectedIndexChanged="grdLeave_SelectedIndexChanged" Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Id" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DocName" HeaderText="Doc Name" ItemStyle-CssClass="GridViewLabItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="200px" />
                                    <asp:BoundField DataField="LeaveReason" HeaderText="Reason" ItemStyle-CssClass="GridViewLabItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="200px" />
                                    <asp:BoundField DataField="Date" HeaderText="Date" ItemStyle-CssClass="GridViewLabItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="120px" />
                                    <asp:BoundField DataField="IsActive" HeaderText="Active" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-CssClass="GridViewLabItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="80px" />
                                    <asp:TemplateField HeaderText="Active" Visible="false">
                                        <ItemTemplate>
                                            <div style="display: none;">
                                                <asp:Label ID="lblrecord" runat="server" Text='<%# Eval("ID")+"#"+Eval("LeaveReason")+"#"+Eval("Date")+"#"+Eval("IsActive")+"#"+Eval("DoctorID")+"#"+Eval("IsTime")+"#"+Eval("FromTime")+"#"+Eval("ToTime")%>'></asp:Label>
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                    </asp:TemplateField>
                                    <asp:CommandField ButtonType="Image" ShowSelectButton="true" HeaderText="Select" SelectImageUrl="~/Images/Post.gif">
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        <ItemStyle CssClass="GridViewLabItemStyle" />
                                    </asp:CommandField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>

<%--            </ContentTemplate>
        </Ajax:UpdatePanel>--%>
    </div>
</asp:Content>
