<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="PatientGrouping.aspx.cs" Inherits="Design_BloodBank_PatientGrouping" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                // if the key pressed is the escape key, dismiss the dialog
                $find('mpeCreateGroup').hide();
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtdonationfrom').change(function () {
                ChkDate();
            });
            $('#txtdonationTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtdonationfrom').val() + '",DateTo:"' + $('#txtdonationTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=pnlhide.ClientID %>,#<%=grdGrouping.ClientID %>').hide();
                        $('#<%=btnSearch.ClientID %>').prop('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeProp('disabled');

                    }
                }
            });
        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".status").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = 'cyan';
            });
            $(".status").mouseout(function () {
                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });
            $(".history").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = '#C2D69B';
            });
            $(".history").mouseout(function () {
                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });

        });



        function RestrictDoubleEntry(btn) {

            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$Button1', '');
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Patient ABO & RH Blood Grouping</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div id="Div1" class="Purchaseheader" runat="server">
                Patient Search
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="OPD">OPD</asp:ListItem>
                                <asp:ListItem Text="IPD">IPD</asp:ListItem>
                                <asp:ListItem Text="EMG">EMG</asp:ListItem>
                                <asp:ListItem Text="ALL" Selected="True">ALL</asp:ListItem>
                            </asp:RadioButtonList>
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
                            <asp:TextBox ID="txtUHID" runat="server" TabIndex="3" MaxLength="20"></asp:TextBox>
                        </div>
                        
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" TabIndex="3" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdonationfrom" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldonationfrom"
                                TargetControlID="txtdonationfrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdonationTo" runat="server" ClientIDMode="Static" TabIndex="6"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldonationTo"
                                TargetControlID="txtdonationTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               Grouping
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbtnGrouping" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Text="NO" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="0" Text="YES"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" TabIndex="7"
                OnClick="btnSearch_Click" />&nbsp;
        </div>
        <asp:Panel ID="pnlhide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="" style="text-align: center;">
                    <asp:GridView ID="grdGrouping" runat="server" AutoGenerateColumns="false" Width="100%" CssClass="GridViewStyle"
                        OnRowCommand="grdGrouping_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Type" HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                   <asp:Label ID="lblType" runat="server" Text='<%#Eval("Type") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Collection ID" HeaderStyle-Width="110px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblCollectionID" runat="server" Text='<%# Eval("CollectionID") %>'></asp:Label>
                                    
                                </ItemTemplate>
                            </asp:TemplateField>
                                <asp:TemplateField HeaderText="GroupID" HeaderStyle-Width="110px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblGroupingID" runat="server" Text='<%#Eval("Grouping_Id") %>'></asp:Label>
                                    
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblID" runat="server" Text='<%# Eval("Visitor_ID") %>'></asp:Label>
                                    <asp:Label ID="lblPatientID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                    <asp:Label ID="lblTransactionID" runat="server" Text='<%#Eval("TransactionID") %>'></asp:Label>
                                    <asp:Label ID="lblLedgertransaction" runat="server" Text='<%#Eval("LedgerTransactionNo") %>'></asp:Label>
                                    <asp:Label ID="lblMotherID" runat="server" Text='<%#Eval("MotherTID") %>'></asp:Label>
                                    <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>'></asp:Label>
                                   
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Name" HeaderStyle-Width="220px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("PName") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age/Sex" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblAgesex" runat="server" Text='<%# Eval("AgeSex") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="UHID" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                  <asp:Label ID="lblUHID" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Blood Component" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                   <asp:Label ID="lblBloodComponent" runat="server" Text='<%#Eval("Blood Component") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Blood Group" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblGroup" runat="server" Text='<%# Eval("BloodGroup") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Room" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblRoom" runat="server" Text='<%# Eval("ward") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Select" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/view.gif" class="status"
                                        CommandName='<%#Eval("Status") %>' CommandArgument='<%#Container.DataItemIndex %>' CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="History" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgHistory" runat="server" ImageUrl="../../Images/Post.gif" class="history"
                                        CommandName="AHistory" CommandArgument='<%#Container.DataItemIndex %>' CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="panelbloodmatch" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="" style="text-align: center;">
                    <asp:GridView ID="grdBloodMatch" runat="server" CssClass="GridViewStyle" Width="100%" AutoGenerateColumns="false"
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
                            <asp:TemplateField HeaderText="Collection ID">
                                <ItemTemplate>
                                    <asp:Label ID="lblDonationID" runat="server" Text='<%# Eval("BloodCollection_Id") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Sample">
                                <ItemTemplate>
                                    <%# Eval("Sample") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <%#Eval("CreatedDate")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AntiA">
                                <ItemTemplate>
                                    <%#Eval("AntiA")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <%--<asp:TemplateField HeaderText="AntiA1">
                                <ItemTemplate>
                                    <%#Eval("AntiA1")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="AntiB">
                                <ItemTemplate>
                                    <%#Eval("AntiB")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AntiAB">
                                <ItemTemplate>
                                    <%#Eval("AntiAB")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="RH">
                                <ItemTemplate>
                                    <%#Eval("RH")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tested BG">
                                <ItemTemplate>
                                    <asp:Label ID="lblBloodTested" runat="server" Text='<%# Eval("BloodTested") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Matched">
                                <ItemTemplate>
                                    <%#Eval("IsSame")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ACell">
                                <ItemTemplate>
                                    <%#Eval("ACell")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="BCell">
                                <ItemTemplate>
                                    <%#Eval("BCell")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OCell">
                                <ItemTemplate>
                                    <%#Eval("OCell")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <%--<asp:TemplateField HeaderText="PtCell">
                                <ItemTemplate>
                                    <%#Eval("PtCell")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="Serum's BG">
                                <ItemTemplate>
                                    <%#Eval("BloodGroupAlloted")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    &nbsp;<br />
                    <asp:Label ID="lblTestRes" runat="server" Visible="false"></asp:Label>
                    <asp:GridView ID="grdResult" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="false"
                        Visible="false">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="ID">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <%# Eval("Type") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="WB">
                                <ItemTemplate>
                                    <%# Eval("WB") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PC">
                                <ItemTemplate>
                                    <%# Eval("PC") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Plasma">
                                <ItemTemplate>
                                    <%# Eval("Plasma") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:Button ID="btnOk" runat="server" Text="OK" Visible="false" CssClass="ItDoseButton"
                        OnClick="btnOk_Click" />
                </div>
            </div>
        </asp:Panel>

        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
            <asp:Label ID="lblhidden" runat="server" Text="Label" Visible="false"></asp:Label>
            <asp:Label ID="lblLedger" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblSample" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblIndex" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblId" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblMtype" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblMTested" runat="server" Visible="false"></asp:Label>

        </div>
        <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="598px" Height="228px">
            <div class="Purchaseheader" id="dragUpdate" runat="server">
                Processing
                       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Press esc to close
            </div>
            <div style="text-align: center;">
                <asp:Label ID="lblerrMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <asp:Label ID="lblvisitors_id" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="lbloldGroupID" runat="server" Visible="false"></asp:Label>
            </div>
            <div class="">
                <div>
                    <table>
                        <tr>
                            <td>Collection ID :
                            </td>
                            <td>
                                <asp:Label ID="lblDonation1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>Name :
                            </td>
                            <td>
                                <asp:Label ID="lblName1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>Blood Group(Screened) :
                            </td>
                            <td>
                                <asp:Label ID="lblGroup1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:Label ID="lblPatientID1" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblTransactionID1" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblLedgerTransaction1" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblMotherID1" runat="server" Visible="false"></asp:Label>
                                <asp:Label ID="lblItemID1" runat="server" Visible="false"></asp:Label>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="float: left;display:none">
                    <div style="text-align: center;">
                        &nbsp;<asp:DataList ID="dtInvestigation" runat="server" RepeatDirection="Horizontal"
                            SeparatorStyle-BorderColor="Black" SeparatorStyle-BorderStyle="Dashed" BorderStyle="Double"
                            BorderColor="black" Width="590px" HeaderStyle-BackColor="green" CellPadding="4"
                            ForeColor="#333333">
                            <HeaderTemplate>
                                Investigation:
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblItem" runat="server" Text='<%# Eval("Name")%>'></asp:Label>&nbsp;&nbsp;<br />
                                <asp:DropDownList ID="ddlInvestigation" runat="server" Width="50px">
                                    <%--<asp:ListItem Text="--" Value="0" Selected="True"></asp:ListItem>--%>
                                    <asp:ListItem Text="N" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="P" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;&nbsp;
                            </ItemTemplate>
                            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                            <AlternatingItemStyle BackColor="White" />
                            <ItemStyle BackColor="#E3EAEB" />
                            <SeparatorStyle BorderColor="Black" BorderStyle="Dashed" />
                            <SelectedItemStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333" />
                            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
                        </asp:DataList>
                    </div>
                </div>
            </div>
            <div class="filterOpDiv" style="text-align: center; display:none">
                <asp:Button ID="Button2" Text="Save" AccessKey="W" CssClass="ItDoseButton" OnClientClick="return RestrictDoubleEntry(this);"
                    runat="server" TabIndex="13" OnClick="Button1_Click" />&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCancel1" Text="Cancel" CssClass="ItDoseButton" runat="server"
                    CausesValidation="False" />&nbsp;
                <br />
                <div style="overflow: auto; float: left;">
                    <asp:GridView ID="gridmatch" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:TemplateField HeaderText="AntiA">
                                <ItemTemplate>
                                    <%# Eval("AntiA") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AntiB">
                                <ItemTemplate>
                                    <%# Eval("AntiB") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="AntiAB">
                                <ItemTemplate>
                                    <%# Eval("AntiAB") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="RH">
                                <ItemTemplate>
                                    <%# Eval("RH") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="BloodAlloted">
                                <ItemTemplate>
                                    <%# Eval("BloodAlloted")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="BGGroup">
                                <ItemTemplate>
                                    <%# Eval("BGGroup")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div>
                    <asp:GridView ID="grdMatch1" runat="server" AutoGenerateColumns="false">
                        <Columns>
                            <asp:TemplateField HeaderText="ACell">
                                <ItemTemplate>
                                    <%# Eval("ACell") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="BCell">
                                <ItemTemplate>
                                    <%# Eval("BCell")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="OCell">
                                <ItemTemplate>
                                    <%# Eval("OCell") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="BloodAlloted">
                                <ItemTemplate>
                                    <%# Eval("BloodGroupAlloted")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
              <div style="display: none">
                <table style="margin-top: 71px;">
                    <tr>
                        <td style="font-weight: 600;">Blood Group :
                        </td>
                        <td>
                            <asp:Label ID="lblbloodGroup" Style="color: red; font-weight: 600;" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;
                        </td>
                        <td style="font-weight: 600;">RH :
                        </td>
                        <td>
                            <asp:Label ID="lblRH" Style="color: red; font-weight: 600;" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;
                        </td>

                        <td>&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
            <div class="row">
                <div class="col-md-24"></div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <label class="pull-left">Blood Group</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlBloodGroupNew" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-6">
                    <label class="pull-left">Rh Value</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlRh" runat="server">
                        <asp:ListItem Text="Positive" Value="+"></asp:ListItem>
                        <asp:ListItem Text="Negative" Value="-"></asp:ListItem>
                        <asp:ListItem Text="Week Positive" Value="W+"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <br />
            <br />
            <div class="row" style="text-align: center">
                <asp:Button ID="Button1" Text="Save" AccessKey="W" CssClass="ItDoseButton"
                    runat="server" TabIndex="13" OnClick="Button1_Click" />&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" runat="server"
                    CausesValidation="False" />&nbsp;
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnCancel"
            DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlUpdate" PopupDragHandleControlID="pnlUpdate" BehaviorID="mpeCreateGroup">
        </cc1:ModalPopupExtender>
    </div>
</asp:Content>
