<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="OpdPatientSearchMRD.aspx.cs" Inherits="Design_MRD_OpdPatientSearchMRD" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

        });

       
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
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
        function validateIssue() {
            if (typeof (Page_Validators) == "undefined") return;
            var Issue = document.getElementById("<%=reqIssue.ClientID%>");
            var LblName = document.getElementById("<%=lblIssue.ClientID%>");
            ValidatorValidate(Issue);
            if (!Issue.isvalid) {
                LblName.innerText = Issue.errormessage;
                return false;
            }

        }
        function validateReturn() {
            if (typeof (Page_Validators) == "undefined") return;
            var Return = document.getElementById("<%=reqReturn.ClientID%>");
            var LblName = document.getElementById("<%=lblReturn.ClientID%>");
            ValidatorValidate(Return);
            if (!Return.isvalid) {
                LblName.innerText = Return.errormessage;
                return false;
            }


        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpopIssue")) {
                    $find("mpopIssue").hide();
                    
                }
                if ($find("mpopReturn")) {
                    $find("mpopReturn").hide();
                }
            }
        }
        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtIssueRemarks.ClientID %>,#<%=txtReturnRemarks.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtIssueRemarks.ClientID%>,#<%=txtReturnRemarks.ClientID %>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Patient Search MRD</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;</div>
            <table cellpadding="0" cellspacing="0" style="width: 95%; height: 20px">
                <tr>
                    <td style="width: 15%; height: 20px; text-align: right" class="ItDoseLabel">
                        From Date :&nbsp;
                    </td>
                    <td style="width: 35%; height: 20px; text-align: left">
                        <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                            Width="170px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 15%; height: 20px; text-align: right" class="ItDoseLabel">
                        To Date :&nbsp;
                    </td>
                    <td style="width: 35%; height: 20px; text-align: left">
                        <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                            Width="170px"></asp:TextBox>
                        <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                       &nbsp;
                    </td>
                </tr>
              
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="3" Text="Search"
                    OnClick="btnSearch_Click" ToolTip="Click to Search" />
                     <br />
                <div id="colorindication">
                    <table style="width: 676px">
                                <tr>
                                <td style="width: 130px"></td><td style="width: 130px"></td>

                                <td style="background-color: lightpink; width: 30px">
                                </td>
                                <td style="text-align: left;width: 30px">
                                    File&nbsp;Issue
                                <td style="background-color: lightgreen; width: 30px">
                                </td>
                                <td style="text-align: left;width: 30px">
                                    File&nbsp;Return
                                </td>
                                <td>
                                </td>
                            </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                Result</div>
            <table id="tbAppointment">
                <tr align="center">
                    <td>
                        <asp:GridView ID="grdMRD" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdMRD_RowCommand" OnRowDataBound="grdMRD_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRNo" runat="server" Text='<%#Util.GetString(Eval("PatientID")) %>'></asp:Label>
                                        <asp:Label ID="lblLedgerTnxNo" runat="server" Text='<%#Eval("LedgerTnxNo") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblIssueStatus" runat="server" Text='<%#Eval("IsIssue") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblReturnStatus" runat="server" Text='<%#Eval("IsReturn") %>' Visible="false"></asp:Label>
                                        
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="AppID" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAppID" runat="server" Text='<%#Eval("App_ID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="30" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="AppNo" HeaderText="App No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="60" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("NAME") %>'></asp:Label>
                                        <asp:Label ID="lblTransactionid" runat="server" Text='<%#Eval("TransactionID") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name"> 
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                 <asp:TemplateField HeaderText="Patient Type">
                                    <ItemTemplate>
                                        <asp:Label ID="lblvisit" runat="server" Text='<%#Eval("VisitType") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                             
                                <asp:BoundField DataField="AppTime" HeaderText="App Time">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AppDate" HeaderText="App Date">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="ConformDate" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblConfirmdate" runat="server" Text='<%#Eval("ConformDate") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="File&nbsp;Issue" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                                    <ItemTemplate>
                                        <asp:Button ID="btnFileIssue" runat="server" Text="File Issue" CommandName="FileIssue"
                                            CommandArgument='<%# Container.DataItemIndex %>' ToolTip="Click to Issue File" CssClass="ItDoseButton"/>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="File&nbsp;Return">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="100px" />
                                    <ItemTemplate>
                                        <asp:Button ID="btnFileReturn" runat="server" Text="File Return" CommandName="FileReturn"
                                            CommandArgument='<%#Container.DataItemIndex %>' ToolTip="Click to Return File" CssClass="ItDoseButton"/>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="View Details">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbViews" runat="server" CausesValidation="false" CommandName="AViewDetail" CommandArgument='<%# Eval("PatientID")+"#"+Eval("App_ID")  %>'
                                    ImageUrl="~/Images/view.GIF"  />
                               
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <cc1:ModalPopupExtender ID="mpopIssue" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlIssue" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnHidden" BehaviorID="mpopIssue">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlIssue" runat="server" CssClass="pnlOrderItemsFilter"  Style="display:none">
        <div runat="server" class="Purchaseheader">
            <b>Issue File </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; Press
            esc to close
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 712px">
            <tr>
                <td style="height: 16px;" align="center" colspan="4">
                    <asp:Label ID="lblIssue" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 14%;" align="right">
                    UHID :&nbsp;
                </td>
                <td style="width: 29%; " align="left">
                    <asp:Label ID="lblIssuePatientID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    <asp:Label ID="lblAppID" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                </td>
                <td style="width: 17%; " align="right">
                    Patient Name :&nbsp;
                </td>
                <td style="width: 80%; " align="left">
                    <asp:Label ID="lblIssuePatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    <asp:Label ID="lblDate" runat="server" Visible="false"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 14%; ">
                    Issue Date :&nbsp;
                </td>
                <td align="left" style="width: 29%; ">
                    <asp:TextBox ID="txtIssueDate" runat="server" TabIndex="1" ToolTip="Select Issue Date"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                    <cc1:CalendarExtender ID="calIssueDate" runat="server" TargetControlID="txtIssueDate"
                        Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </td>
                <td align="right" style="width: 17%; ">
                    Issue&nbsp;Remarks :&nbsp;
                </td>
                <td align="left" style="width: 38%; ">
                    <asp:TextBox ID="txtIssueRemarks" TextMode="MultiLine" Width="207px" Height="30px"
                        runat="server" TabIndex="2" ToolTip="Enter Issue Remarks"></asp:TextBox><asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    
                    <asp:RequiredFieldValidator ID="reqIssue" runat="server" ControlToValidate="txtIssueRemarks"
                        Display="None" ErrorMessage="Please Enter Issue Remarks" SetFocusOnError="True"
                        ValidationGroup="Save"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 14%; ">
                
                <asp:Label ID="lblissueroomno" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="lblissuerackno" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="lblissueshelno" runat="server" Visible="false"></asp:Label>

                </td>
                <td align="center" colspan="2" >
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnIssueSave" runat="server" CssClass="ItDoseButton" 
                        OnClick="btnIssueSave_Click" OnClientClick="return validateIssue();" 
                        TabIndex="3" Text="Save" ToolTip="Click to Save" ValidationGroup="Save" />
                    <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" TabIndex="4" 
                        Text="Close" ToolTip="Click to Close" />
                    &nbsp;
                </td>
                <td align="left" style="width: 38%;">
                </td>
            </tr>
        </table>
        <br />
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpopReturn" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlReturn" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnHidden" BehaviorID="mpopReturn">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlReturn" runat="server" CssClass="pnlOrderItemsFilter"  Style="display:none"
        Width="818px"  >
        <div id="Div1" runat="server" class="Purchaseheader">
            <b>Return File </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; 
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Press esc to close
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 816px">
            <tr>
                <td style="height: 14px;" align="center" colspan="4">
                    <asp:Label ID="lblReturn" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr><td  align="right" style="width: 7%">Room :&nbsp;</td>
            <td style="width: 16%">
            <asp:UpdatePanel ID="UpdtpnlRoom" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="cmbRoom" ToolTip="Select Room" runat="server" Width="151px"
                                     OnSelectedIndexChanged="cmbRoom_SelectedIndexChanged" AutoPostBack="true" TabIndex="1">
                                </asp:DropDownList>
                                <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                <asp:RequiredFieldValidator ID="reqFileRoom" SetFocusOnError="true" runat="server" ControlToValidate="cmbRoom"
                        ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Room" Display="None"></asp:RequiredFieldValidator>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="cmbRoom" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
            </td><td style="width: 8%"  align="right">Rack :&nbsp;</td><td>
            <asp:UpdatePanel ID="UpdtpnlAlmirah" runat="server">
                            <ContentTemplate>
                                <asp:DropDownList ID="cmbAlmirah" runat="server" Width="151px" OnSelectedIndexChanged="cmbAlmirah_SelectedIndexChanged"
                                    AutoPostBack="true" ToolTip="Select Rack" TabIndex="2">
                                </asp:DropDownList>
                                <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                 <asp:RequiredFieldValidator ID="reqRack" SetFocusOnError="true" runat="server" ControlToValidate="cmbAlmirah"
                        ValidationGroup="SaveFile" InitialValue="Select" ErrorMessage="Please Select Rack" Display="None"></asp:RequiredFieldValidator>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="cmbAlmirah" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
            </td></tr>
            <tr><td  align="right" style="width: 7%">Shelf :&nbsp;</td>
            
            <td style="width: 16%">
             <asp:UpdatePanel ID="UpdtpnlShelf" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="cmbShelf" runat="server" TabIndex="3" Width="128px" AutoPostBack="true"
                                                OnSelectedIndexChanged="cmbShelf_SelectedIndexChanged" ToolTip="Select Shelf">
                                            </asp:DropDownList>

                                            <asp:Label ID="Label9" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server" ControlToValidate="cmbShelf"
                        ValidationGroup="SaveFile" InitialValue="0" ErrorMessage="Please Select Shelf" Display="None"></asp:RequiredFieldValidator>

                                        </ContentTemplate>
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="cmbShelf" EventName="SelectedIndexChanged" />
                                        </Triggers>
                                    </asp:UpdatePanel>
            </td><td style="display: none; text-align:right; width: 8%;">
                        <asp:Label ID="lblFileId" runat="server" Visible="False" Text="Old FileNo. "></asp:Label><asp:Label
                            ID="lblCounter" runat="server" Font-Bold="True"></asp:Label>
                    </td><td>
                    <asp:DropDownList ID="ddlFileNo" runat="server" Visible="False" Width="140px">
                    </asp:DropDownList>
                    <asp:Label ID="lblFileNo" runat="server" Font-Bold="True" Visible="False"></asp:Label>
                </td></tr>
              <tr>
                <td style="width: 7%; height: 16px;" align="right">
                    UHID :&nbsp;
                </td>
                <td style="width: 16%; height: 16px;" align="left">
                    <asp:Label ID="lblReturnPatientID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    <asp:Label ID="lblAppIDReturn" runat="server" CssClass="ItDoseLabelSp" Visible="false"></asp:Label>
                </td>
                <td style="width: 8%; height: 16px;" align="right">
                    Patient Name :&nbsp;
                </td>
                <td style="width: 20%; height: 16px;" align="left">
                    <asp:Label ID="lblReturnPatientName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 7%; height: 16px">
                    Return Date :&nbsp;
                </td>
                <td align="left" style="width: 16%; height: 16px">
                    <asp:TextBox ID="txtReturnDate" runat="server" TabIndex="1" ToolTip="Select Return Date"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                    <cc1:CalendarExtender ID="calReturn" runat="server" TargetControlID="txtReturnDate"
                        Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </td>
                <td align="right" style="width: 8%; height: 16px">
                    Return&nbsp;Remarks :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:TextBox ID="txtReturnRemarks" TabIndex="2" ToolTip="Enter Return Remarks" TextMode="MultiLine"
                        runat="server" Width="240px" Height="44px"></asp:TextBox><asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    <asp:RequiredFieldValidator ID="reqReturn" runat="server" ControlToValidate="txtReturnRemarks"
                        Display="None" ErrorMessage="Please Enter Return Remarks" SetFocusOnError="True"
                        ValidationGroup="Save"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 7%; height: 16px">
                <asp:Label ID="lbltran" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="lblvisittype" runat="server" Visible="false"></asp:Label>
                </td>
                <td align="center" colspan="2" style="height: 16px">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnReturnSave" runat="server" CssClass="ItDoseButton" 
                        OnClick="btnReturnSave_Click" OnClientClick="return validateReturn();" 
                        TabIndex="3" Text="Save" ToolTip="Click to Save" ValidationGroup="Save" />
                    <asp:Button ID="btnReturnCancel" runat="server" CssClass="ItDoseButton" 
                        Text="Close" ToolTip="Click to Close" />
&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                </td>
            </tr>
        </table>
        <br />
    </asp:Panel>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display:none" 
        ScrollBars="Auto" Width="600px">
        <div>
          <div id="Div2" runat="server" class="Purchaseheader">
          File Status
          </div>
            <table style="width: 99%">
                <tr>
                    <td style="width: 131px; text-align:right">
                        
                        File Issue Date :&nbsp;</td>
                <td style="width: 98px; text-align:left"">
               <asp:Label ID="lblIssueDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td style="text-align:right; width: 131px;">
             Issue Remarks :&nbsp;
                </td>
                <td style="text-align:left">
                <asp:Label ID="lblIssueRemarks" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                
                </td>
                </tr>
                <tr>
                    <td style="width: 131px;  text-align:right">
                        File Return date :&nbsp;</td>
                     <td style="width: 98px; text-align:left">
                         <asp:Label ID="lblReturnDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                     </td>
                <td style="text-align:right; width: 131px;">
                Return Remarks :&nbsp;
                </td>
                <td style="text-align:left">
                <asp:Label ID="lblReturnRemarks" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                </tr>
                  <tr>
                    <td style="width: 131px;  text-align:right">
                        <asp:Label ID="lblRoom" runat="server" Text="Room Name :" ></asp:Label>&nbsp;</td>
                     <td style="width: 98px; text-align:left">
                         <asp:Label ID="lblRoomno" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                <td style="text-align:right; width: 131px;">
                    <asp:Label ID="lblRack" runat="server" Text="Rack Name :" ></asp:Label>&nbsp;
                </td>
                <td style="text-align:left">
                    <asp:Label ID="lblRackno" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                      </td>
                </tr>
                  <tr>
                    <td style="width: 131px;  text-align:right">
                        <asp:Label ID="lblshelf" runat="server" Text="Shelf No. :" ></asp:Label>&nbsp;</td>
                     <td style="width: 98px; text-align:left">
                         <asp:Label ID="lblShelfNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label></td>
                <td style="text-align:right; width: 131px;">
                    &nbsp;
                </td>
                <td style="text-align:left">
                    &nbsp;</td>
                </tr>
                <tr>
                <td></td>
                <td style="width: 30px"></td>
                    <td style="text-align: center; width: 131px;">
                        <asp:Button ID="btnCancel1" runat="server" Text="Close" CssClass="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="Panel2"
        TargetControlID="btn1" X="80" Y="100">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton"/></div>
</asp:Content>
