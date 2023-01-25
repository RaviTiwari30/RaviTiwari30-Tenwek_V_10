<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientGroupingApproval.aspx.cs" Inherits="Design_BloodBank_PatientGroupingApproval" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#txtcollectedfrom').change(function () {
                ChkDate();
            });
            $('#txtcollectedTo').change(function () {
                ChkDate();
            });
            $(".approve").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = 'cyan';
            });
            $(".approve").mouseout(function () {
                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });
            $(".reject").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = '#C2D69B';
            });
            $(".reject").mouseout(function () {
                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtcollectedfrom').val() + '",DateTo:"' + $('#txtcollectedTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdBloodMatch.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeProp('disabled');
                    }
                }
            });
        }
        function clearAllField() {
            a = document.getElementsByTagName("input");
            for (i = 0; i < a.length; i++) {
                if (a[i].type == "text") {
                    a[i].value = "";
                }
            }
            a = document.getElementsByTagName("textarea");
            for (i = 0; i < a.length; i++) {
                a[i].value = "";
            }
        }

        function chkRemarks() {
            if ($("#<%=txtRemark.ClientID%>").val() == "") {
                // $("#<%=lblMsg.ClientID%>").text('Please Enter Remarks');
                modelAlert("Please Enter Remarks");
                $("#<%=txtRemark.ClientID%>").focus();
                return false;
            }
        }
    </script>

     <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Grouping Approval</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">
            <div id="Div1" class="Purchaseheader" runat="server">
                Donor Search
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" MaxLength="20" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server" MaxLength="20" TabIndex="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodgroup" runat="server"
                                 TabIndex="4">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect  From 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectedfrom" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectedfrom"
                                TargetControlID="txtcollectedfrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect  To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectedTo" runat="server" ClientIDMode="Static" TabIndex="6"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectedTo"
                                TargetControlID="txtcollectedTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="OPD" Value="OPD">OPD</asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD">IPD</asp:ListItem>
                                <asp:ListItem Text="EMG" Value="EMG">EMG</asp:ListItem>
                                <asp:ListItem Text="ALL" Selected="True" Value="All">ALL</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" TabIndex="7"
                OnClick="btnSearch_Click" />&nbsp;
            <asp:Label ID="lblHdn2" runat="server" Visible="false"></asp:Label>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <asp:GridView ID="grdBloodMatch" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false"
                        OnRowCommand="grdBloodMatch_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <%#Eval("Name")%>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age/Sex">
                                <ItemTemplate>
                                    <%#Eval("AgeSex")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <%#Eval("CollectedDate")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AntiA">
                                <ItemTemplate>
                                    <%#Eval("AntiA")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="AntiB">
                                <ItemTemplate>
                                    <%#Eval("AntiB")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AntiAB">
                                <ItemTemplate>
                                    <%#Eval("AntiAB")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="RH">
                                <ItemTemplate>
                                    <%#Eval("RH")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tested BloodGP">
                                <ItemTemplate>
                                    <asp:Label ID="lblBloodTested" runat="server" Text='<%# Eval("BloodTested") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:TemplateField>
                            
                            <asp:TemplateField HeaderText="Approve" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgApprove" runat="server" ImageUrl="~/Design/BloodBank/Images/thumbsup.gif"
                                        class="approve" Visible="true" CommandName="AApprove" CommandArgument='<%#Eval("Grouping_Id") %>'
                                        CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgReject" runat="server" ImageUrl="~/Design/BloodBank/Images/thumbsdwn.gif"
                                        class="reject" CommandName="AReject" CommandArgument='<%#Eval("Grouping_Id") %>' CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <div>
                        <asp:Label ID="lblhidden" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblPatientID1" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblRemark" runat="server" Text="Add Remark :" Visible="false"></asp:Label>
                        <asp:TextBox ID="txtRemark" runat="server" Width="500px" Visible="false"></asp:TextBox>
                        <span style="color: red; font-size: 10px;" id="spnRemark">*</span>

                        <asp:Button ID="btnRemark" runat="server" Text="Post" Visible="false" OnClick="btnRemark_Click" CssClass="ItDoseButton"
                            ValidationGroup="Remark" OnClientClick="return chkRemarks()" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" Visible="false" CssClass="ItDoseButton" />
                    </div>
                    &nbsp;
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

