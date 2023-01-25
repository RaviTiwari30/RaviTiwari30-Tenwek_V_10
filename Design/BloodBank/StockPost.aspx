<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="StockPost.aspx.cs" Inherits="Design_BloodBank_StockPost" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
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
            $('#txtcollectionfrom').change(function () {
                ChkDate();
            });
            $('#txtcollectionTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtcollectionfrom').val() + '",DateTo:"' + $('#txtcollectionTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblerrmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdStock.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblerrmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeProp('disabled');
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(function () {
            $(".post").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = 'cyan';
            });
            $(".post").mouseout(function () {
                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });
        });
        var oldgridcolor;
        function SetMouseOver(element) {
            oldgridcolor = element.style.backgroundColor;
            element.style.backgroundColor = '#C2D69B';
            element.style.cursor = 'pointer';
            element.style.textDecoration = 'underline';
        }
        function SetMouseOut(element) {
            element.style.backgroundColor = oldgridcolor;
            element.style.textDecoration = 'none';
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
        function validate() {
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Post Stock</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="col-md-1"></div>
            <div class="col-md-22">
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            Blood Collection ID
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtCollectionId" runat="server" MaxLength="20"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server"
                            ControlToValidate="txtCollectionId" ValidationGroup="btnSave" InitialValue="0"
                            ErrorMessage="*" Display="None"></asp:RequiredFieldValidator>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            Donation ID
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtDonationId" runat="server" MaxLength="20"></asp:TextBox>
                    </div>
                </div>
                <div class="row">

                    <div class="col-md-4">
                        <label class="pull-left">
                            Collection From Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtcollectionfrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calcollectionfrom" TargetControlID="txtcollectionfrom"
                            Format="dd-MMM-yyyy" Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            Collection To Date
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtcollectionTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calcollectionTo" TargetControlID="txtcollectionTo" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </div>
                </div>
            </div>
            <div class="col-md-1"></div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server" OnClick="btnSearch_Click" />&nbsp;
           
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:GridView ID="grdStock" runat="server" AutoGenerateColumns="false" Width="100%" CssClass="GridViewStyle"
                    OnRowCommand="grdGridView_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor ID" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDonorID1" runat="server" Text='<%# Eval("Visitor_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection ID" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblCollectionID" runat="server" Text='<%# Eval("BloodCollection_Id") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection Date" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblCollectionDate" runat="server" Text='<%# Eval("CollectionDate") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tube No." HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBBTubeNo" runat="server" Text='<%# Eval("BBTubeNo") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBagType" runat="server" Text='<%# Eval("BagType") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Blood Tested" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodTested" runat="server" Text='<%# Eval("BloodTested") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IsActive" Visible="false">
                            <ItemTemplate>
                                <div style="display: none;">
                                    <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("Visitor_ID")+"#"+Eval("BloodCollection_Id")+"#"+Eval("BBTubeNo")+"#"+Eval("BagType")%>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post" HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgSelect" runat="server" ImageUrl="../../Images/view.gif" CommandName="ASelect"
                                    class="post" CommandArgument='<%#Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
        </div>
    </div>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlSurgeryItemsFilter" Width="700px"
        Style="display: none">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Stock Post: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
            Press esc to close
        </div>
        <div class="content">
            <asp:Label ID="lblDonorID1" runat="server" Visible="False"></asp:Label>
            <div>
                <asp:Label ID="lblbagType1" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lblTubeNo1" runat="server" Visible="False"></asp:Label>
                <asp:Label ID="lblBloodTested1" runat="server" Visible="False"></asp:Label>
                <%--<asp:Label ID="lblExpiry" runat="server" Visible="False"></asp:Label>--%>
                <div style="float: left; clear: right; padding-left: 150px;">
                    <label class="labelForTag">
                        Name :&nbsp;</label>
                    <asp:Label ID="lblName1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;<br />
                    <br />
                </div>
                <div style="float: left; padding-left: 50px; width: 310px; height: 49px;">
                    <label class="labelForTag">
                        Collection ID :&nbsp;</label>&nbsp;
                    <asp:Label ID="lblBloodCollectionId1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </div>
            </div>
            <br />
            <div class="content" style="text-align: center;">
                <asp:GridView ID="grvCom" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowDataBound="grvCom_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ComponentName">
                            <ItemTemplate>
                                <asp:Label ID="lblComponentName" Text='<%# Eval("ComponentName") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="270px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Volume">
                            <ItemTemplate>
                                <asp:Label ID="lblVolumn2" Text='<%# Eval("volumn") %>' runat="server"></asp:Label>
                                ml
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type">
                            <ItemTemplate>
                                <asp:Label ID="lblBagType2" Text='<%# Eval("BagType") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiryDate2" Text='<%# Eval("ExpiryDate") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component_ID" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblComponentID2" Text='<%# Eval("Component_ID") %>' runat="server"></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
        <div class="filterOpDiv" style="text-align: center;">
            <asp:Button ID="btnSave" ValidationGroup="btnSave" AccessKey="W" Text="Save" CssClass="ItDoseButton"
                runat="server" TabIndex="15" OnClick="btnSave_Click" OnClientClick="return validate();" />&nbsp;&nbsp;
            &nbsp;
            <asp:Button ID="btnCancel" Text="Cancel" CssClass="ItDoseButton" runat="server" CausesValidation="False" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate" PopupDragHandleControlID="pnlUpdate" BehaviorID="mpeCreateGroup">
    </cc1:ModalPopupExtender>
</asp:Content>
