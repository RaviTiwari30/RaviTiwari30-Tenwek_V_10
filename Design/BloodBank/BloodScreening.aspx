<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="BloodScreening.aspx.cs" Inherits="Design_BloodBank_BloodScreening" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
            $("#txtValue").focus(function () { $(this).empty(); });
            $('#txtcollectfrom').change(function () {
                ChkDate();
            });
            $('#txtcollectTo').change(function () {
                ChkDate();
            });
        });


        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtcollectfrom').val() + '",DateTo:"' + $('#txtcollectTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdDonor.ClientID %>').hide();
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
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Blood Screening</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Coll. Id
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCollectionId" runat="server" TabIndex="1" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor Id
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDonorId" runat="server" TabIndex="2" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" TabIndex="3" MaxLength="50"></asp:TextBox>
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
                            <asp:DropDownList ID="ddlBloodgroup" runat="server" TabIndex="4">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectfrom" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectfrom" TargetControlID="txtcollectfrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcollectTo" runat="server" ClientIDMode="Static" TabIndex="6"></asp:TextBox>
                            <cc1:CalendarExtender ID="calcollectTo" TargetControlID="txtcollectTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click"
                ValidationGroup="a" TabIndex="7" />
            <asp:Label ID="lblScreeningID" runat="server" Visible="false"></asp:Label>
            <asp:Label ID="lblBloodcollectionid1" runat="server" Visible="false"></asp:Label>


        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:GridView ID="grdDonor" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdDonor_RowCommand" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor ID" HeaderStyle-Width="110px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDonorID" runat="server" Text='<%# Eval("Visitor_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor ID" HeaderStyle-Width="110px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblVisitID" runat="server" Text='<%# Eval("Visit_ID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection ID" HeaderStyle-Width="120px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblBloodcollectionid" runat="server" Text='<%# Eval("Bloodcollection_id") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name" HeaderStyle-Width="220px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sex" HeaderStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Eval("Gender")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tube No." HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblTubeNo" runat="server" Text=' <%#Eval("bbTubeNo")%>'></asp:Label>
                                <asp:Label ID="lblBagType" runat="server" Text=' <%#Eval("BagType")%>' Visible="false"></asp:Label>
                                <asp:Label ID="lblVolumn" runat="server" Text=' <%#Eval("volume")%>' Visible="false"></asp:Label>
                                <asp:Label ID="lblResultStep" runat="server" Text=' <%#Eval("ResultStep")%>' Visible="false"></asp:Label>
                                <asp:Label ID="lblIsApproved" runat="server" Text=' <%#Eval("IsApproved")%>' Visible="false"></asp:Label>
                                <asp:Label ID="lblBagStatus" runat="server" Text=' <%#Eval("BagStatus")%>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Group" HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblGroup" runat="server" Text='<%# Eval("BloodGroup") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collected Date" HeaderStyle-Width="110px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDonationDate" runat="server" Text='<%#Eval("Collecteddate")%>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" HeaderStyle-Width="60px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblScreeningID" runat="server" Text='<%#Eval("Screening_Id") %>' Visible="false"></asp:Label>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/view.gif" CommandName="AResult"
                                    class="status" CommandArgument='<%#Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

            </div>
        </asp:Panel>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
        <asp:Label ID="lblDonerID1" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblDonationDate1" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblVisitID1" runat="server" Visible="False"></asp:Label>
        <asp:Label ID="lblResultStep1" runat="server" Visible="false"></asp:Label>
        <asp:Label ID="lblIsApproved1" runat="server" Visible="false"></asp:Label>
    </div>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlSurgeryItemsFilter" Width="917px" Style="display: none">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Testing Details: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            Press esc to close
        </div>
        <div class="content">
            <div style="text-align: center">
                <table style="text-align: center">
                    <tr>
                        <td>Name :&nbsp;
                            <asp:Label ID="lblName1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Blood Group :&nbsp;
                            <asp:Label ID="lblGroup1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Bag Type :&nbsp;
                            <asp:Label ID="lblBagType1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Tube No. :&nbsp;
                            <asp:Label ID="lblTubeNo1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>Volume :&nbsp;
                            <asp:Label ID="lblVolumn1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
            <div>
            </div>
            <div class="content">
                <asp:GridView ID="grvListForm" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowDataBound="grvListForm_RowDataBound" Width="895px">
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkTest" runat="server" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component">
                            <ItemTemplate>
                                <asp:Label ID="lblGrdTestId" Text='<%# Eval("id") %>' Visible="false" runat="server"></asp:Label>
                                <%# Eval("TestName")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Blood Collection ID">
                            <ItemTemplate>
                                <%# Eval("Bloodcollection_id")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Value">
                            <ItemTemplate>
                                <asp:TextBox ID="txtValue" runat="server" BackColor="#ffffcc" Text="--" Width="80px"
                                    Visible='<%# Util.GetBoolean(Eval("Value")) %>' onfocus="WaterMark(this, event);"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbetxtVolume" runat="server" TargetControlID="txtValue"
                                    FilterType="Numbers,Custom" ValidChars=".-" />
                                <%-- <cc1:TextBoxWatermarkExtender ID="txtwme" runat="server" TargetControlID="txtValue" WatermarkText="--"></cc1:TextBoxWatermarkExtender>--%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Method">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlMethod" runat="server" BackColor="#ffffcc" Width="100px">
                                </asp:DropDownList>
                                 <asp:Label ID="lblDefaultMethodName" runat="server" Visible="false" Text='<%# Eval("DefaultMethodName") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Result">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlResult" runat="server" BackColor="#ffffcc" Width="100px">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server" ControlToValidate="ddlResult"
                                    ValidationGroup="btnSave" InitialValue="0" ErrorMessage="*" Display="None"></asp:RequiredFieldValidator>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
        <br />
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
