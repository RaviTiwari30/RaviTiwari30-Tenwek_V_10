<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DoctorProgressNote.aspx.cs" Inherits="Design_IPD_DoctorProgressNote" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>

</head>
<body>

    <script src="../../Scripts/Common.js" type="text/javascript"></script>

    <form id="form1" runat="server">
        <script type="text/javascript">
            if ($.browser.msie) {
                $(document).on("keydown", function (e) {
                    var doPrevent;
                    if (e.keyCode == 8) {
                        var d = e.srcElement || e.target;
                        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                            doPrevent = d.readOnly
                                || d.disabled;
                        }
                        else
                            doPrevent = true;
                    }
                    else
                        doPrevent = false;
                    if (doPrevent) {
                        e.preventDefault();
                    }
                });
            }


        </script>
        <script type="text/javascript">
            $(document).ready(function () {
                var MaxLength = 2000;
                //$("#txtnote").bind("cut copy paste", function (event) {
                //    event.preventDefault();
                //});
                //$("#txtnote").bind("keypress", function (e) {
                //    // For Internet Explorer  
                //    if (window.event) {
                //        keynum = e.keyCode
                //    }
                //        // For Netscape/Firefox/Opera  
                //    else if (e.which) {
                //        keynum = e.which
                //    }
                //    keychar = String.fromCharCode(keynum)
                //    if (e.keyCode == 39 || keychar == "'") {
                //        return false;
                //    }
                //    if ($(this).val().length >= MaxLength) {
                //        if (window.event)//IE
                //        {
                //            e.returnValue = false;
                //            return false;
                //        }
                //        else//Firefox
                //        {
                //            e.preventDefault();
                //            return false;
                //        }
                //    }
                //});
            });

            function note() {
                if ($.trim($("#<%=txtnote.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Progress Note');
                    $("#<%=txtnote.ClientID%>").focus();
                    return false;
                }
                $("#<%=lblMsg.ClientID%>").text('');
                document.getElementById('<%=btnSave.ClientID%>').disabled = False;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('btnSave', '');
            }
        </script>
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Doctor Progress Note</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtdate" runat="server" ToolTip="Click to Select Date" Width="150px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtdate" Format="dd-MMM-yyyy">
                                    </cc1:CalendarExtender>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                      Pregress Note
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-21">
                                    <asp:TextBox ID="txtnote" CssClass="requiredField" runat="server" TextMode="MultiLine" Height="144" Width="510" onkeypress="CheckSuggestedText(event,this.id)"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Care Plan
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-21">
                                    <asp:TextBox ID="txtCareplan" CssClass="requiredField" runat="server" TextMode="MultiLine" Height="144" Width="510" onkeypress="CheckSuggestedText(event,this.id)"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Text="Save"
                    TabIndex="7" OnClick="btnSave_Click" OnClientClick="return note()" />
                  <asp:Button  ID="btnUpdate" runat="server" OnClientClick="return note()" Text="Update" OnClick="btnUpdate_Click" CssClass="ItDoseButton" Visible="false"/>
                   <asp:Button ID="bynCancel" runat="server" Text="Cancel" OnClick="bynCancel_Click" CssClass="ItDoseButton"  Visible="false"/>
                <asp:Label ID="lblID" runat="server"  Visible="false" ></asp:Label>
            </div>
            <asp:Panel ID="pnlhide" runat="server" Visible="false">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <div class="Purchaseheader">
                        Doctor Progress Note
                    </div>
                    <asp:GridView ID="grid" runat="server" CssClass="GridViewStyle"
                        AutoGenerateColumns="false"
                        OnRowDeleting="grid_RowDeleting" OnRowDataBound="grid_RowDataBound" OnRowCommand="grid_RowCommand" >
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="Date" HeaderText="Date" HeaderStyle-Width="100px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            <asp:TemplateField HeaderText="Progress Note" HeaderStyle-Width="400px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblpro" runat="server" Text='<%#Eval("ProgressNote") %>'></asp:Label>
                                    <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblUserID" Text='<%#Eval("UserID") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblDate" Text='<%#Eval("Date") %>' runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lbluID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Care Plan" HeaderStyle-Width="400px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblCareplan" runat="server" Text='<%#Eval("Careplan") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="EntryBy" HeaderText="Entry By" HeaderStyle-Width="200px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                            
                             <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                  <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>'  ImageUrl="~/Images/edit.png" runat="server" />
                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                               
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                        </asp:TemplateField>

                            <asp:CommandField ShowDeleteButton="True" Visible="false"  HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle" HeaderText="Remove" ItemStyle-HorizontalAlign="Center"
                                HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image" DeleteText="Remove Notes" DeleteImageUrl="~/Images/Delete.gif" />

                        </Columns>
                    </asp:GridView>
                    <br />


                </div>
            </asp:Panel>



        </div>
    </form>

    <script type="text/javascript">

        //*****Global Variables*******
        var items = [];
        //// END ////

        $(document).ready(function () {
            GetCodeData();


        });


        function CheckSuggestedText(event, textId) {

            var str = $('#' + textId + '').val();
            if (str.indexOf("@") != -1) {
                var arr = str.split("@");

                // debugger;
                if (arr[arr.length - 1].length == 4) {
                    GetSuggestionText(arr[arr.length - 1], textId, event, function (callback) { })
                }
            }


        }


        function GetSuggestionText(code, textId, event, callback) {
            var str = $('#' + textId + '').val();
            var replacment = '@' + code;
           
            if (event.keyCode == 32) {
                var filteredValue = items.filter(function (item) {
                    return item.Code == code.toUpperCase();
                });
                if (filteredValue.length > 0) {

                    // If Want To Replace All  Matching Word from string Uncomment Bellow line 

                    /*
                    if (str.indexOf("@") != -1) {
                        var arr = str.split("@");
                    }
                    for (var i = 0; i < arr.length - 1; i++) {
                        str = str.replace(replacment, filteredValue[0].Description)

                    }
                    */
                    
                    // this part only replace last occurrance 
                    var currentIndex = str.lastIndexOf(replacment);
                    str = str.substring(0, currentIndex) + filteredValue[0].Description ;
                    /// 


                    $('#' + textId + '').val(str)

                }

            }
            callback(true)




        }


        function GetCodeData() {

            serverCall('../Employee/CodeMaster.aspx/GetActiveCodeData', {}, function (response) {

                var CodeData = JSON.parse(response);

                if (CodeData.status) {
                    data = CodeData.data;
                    items = data;

                    console.log(items)
                }

            });
        }


    </script>




</body>
</html>
