<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewIssuedFile.aspx.cs" Inherits="Design_MRD_ViewIssuedFile" MasterPageFile="~/DefaultHome.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
  
    <script type="text/javascript" >
        $(function () {
            $('#<%=txtMrno.ClientID%>').focus();
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
                        $('#<%=grdMRD.ClientID %>').hide(); 

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                        $('#<%=grdMRD.ClientID %>').val(null);
                    }
                }
            });
        }
        function ShowPdf(rowobj) {
            var row = rowobj.parentNode.parentNode;
            var RequestID = $(row).find('#lblRequestedID').text();
            var FileID = $(row).find('#lblfileid').text();
            viewPdfDocument('pdfViwer', $(row).find('#lblpdfUrl').text(), 1, function (response) {
                $('#pdfViwer').show();
                $(".FrameClose").show();
                //alert(FileID + "#" + RequestID);
                $.ajax({
                    url: "FileIssuedStatus.aspx/UpdateNotification",
                    data: '{RequestID:"' + RequestID + '",FileID:"' + FileID + '"}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = mydata.d;
                    }
                });
            });
        }
       
        function close_Frame() {
            $('#pdfViwer').hide();
            $(".FrameClose").hide();
        }
        function updateNotification(RequestID, FileID)
        {
            alert(RequestID)
            $.ajax({
                url: "FileIssuedStatus.aspx/UpdateNotification",
                data: '{RequestID:"' + RequestID + '",FileID:"' + FileID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                }
            });
        }
        function openPopup(el) {
            var row = el.parentNode.parentNode;
            var str = $(row).find('#lblpdfUrl').text().split('#')[1];
            //var str = $('#lblpdfUrl').text().split('#')[1];
            var winc = window.open('MrdDocumrntView.aspx?TID=' + str + '', 'popupcircular', 'left=100, top=100, height=520, width=840, status=no, resizable= yes, scrollbars= yes, toolbar= no,location= no, menubar= no');
            winc.focus();
        }

    </script>
  
     

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
       <div  class="POuter_Box_Inventory" style="text-align: center;">
           
            <b>MRD Issued File View</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
           </div>
        <div  class="POuter_Box_Inventory">
              <div class="Purchaseheader">
                Search Criteria
              </div>
            <div class="row">
               <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">UHID No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="txtMrno" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Enter Patient UHID No."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">MRD File No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="txtMrdFileNo" runat="server" TabIndex="3" ToolTip="Enter Patient MRD File No."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">IPD No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="txtIPDNo" runat="server" ToolTip="Enter IPD No." TabIndex="4"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="txtpname" runat="server" ToolTip="Enter Patient Name" TabIndex="2"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Issued Date from</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date" TabIndex="5"></asp:TextBox>
                         <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy" Animated="true" runat="server"> </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Issued Date To</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                            TabIndex="6"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy" Animated="true" runat="server"> </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>

            
            </div>
        <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24" style="text-align: center">
                        <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="7" Text="SEARCH"
                            OnClick="btnSearch_Click" ToolTip="Click to Search" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Return Time exceed</label>

                    </div>

                </div>
                <div>
                </div>
            </div>
                
          
            
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            <b>Result</b>
            </div>
             <div class="table-responsive table-cont">
                    <asp:GridView ID="grdMRD" runat="server" AutoGenerateColumns="False" OnRowDataBound="grdMRD_RowDataBound"  CssClass="GridViewStyle"  Width="100%">
                            <AlternatingRowStyle  />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No">
                                      <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="File ID" >
                                      <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblfileid" runat="server" Text='<%#Eval("fileid") %>' ClientIDMode="Static"></asp:Label>
                                          <asp:Label ID="lblRequestedID" runat="server" Text='<%#Eval("RequestedID") %>' style="display:none" ClientIDMode="Static"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID No. " >
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblpatient_id" runat="server" Text='<%#Eval("patient_id") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                  <asp:TemplateField HeaderText="Patient Name">
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPatientName" runat="server" Text='<%#Eval("patientName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Issue To"  >
                                      <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblIssue_To" runat="server" Text='<%#Eval("issuename") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Issue To Department" >
                                      <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblDepartment" runat="server" Text='<%#Eval("Department") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Issue Date" >
                                          <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblIssueDate" runat="server" Text='<%#Eval("IssueDate") %>'></asp:Label>
                                        <asp:HiddenField ID="hdReturnTime" runat="server" Value='<%#Eval("Avg_ReturnTime") %>'/>
                                    </ItemTemplate>
                                </asp:TemplateField>
                              <asp:TemplateField HeaderText="Issue" Visible="false">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblissuedfrom" runat="server" Text='<%#Eval("issuedfrom") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View">
                                      <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                       <asp:Label ID="lblpdfUrl" runat="server" ClientIDMode="Static"   Text='<%#Eval("UploadStatus")+"#"+Eval("Transaction_id") %>' style="display:none"></asp:Label>
                                        <img id="imgShowPdf" runat="server"  src="../../Images/view.GIF" onclick= "openPopup(this)" />
                                    </ItemTemplate>
                                </asp:TemplateField>               
                            </Columns>
                        </asp:GridView>
               </div>
          
        </div>
 

    </div>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                close_Frame();
            }
        }
    </script>
   </asp:Content>
