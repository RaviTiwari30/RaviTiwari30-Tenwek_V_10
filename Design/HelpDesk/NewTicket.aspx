<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewTicket.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_HelpDesk_NewTicket" EnableViewState="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <style type="text/css">
        .clsoverflow {
            white-space: nowrap; 
    width: 73px; 
    overflow: hidden;
    text-overflow: ellipsis;
        }
    </style>
    <script type="text/javascript">
        

        function bindErrorType() {
            $('#lblErrormsg').text('');
            var ErrorType = $("#ddlErrorType");
            $("#ddlErrorType option").remove();

            $.ajax({
                url: "Services/HelpDesk.asmx/bindErrorType",
                data: '{ Department: "' + $("#ddlDepartment").val() + '"}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    ErrorData = jQuery.parseJSON(result.d);
                    if (ErrorData.length == 0) {
                        ErrorType.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < ErrorData.length; i++) {
                            ErrorType.append($("<option></option>").val(ErrorData[i].error_id).html(ErrorData[i].error_type));
                        }
                    }
                    ErrorType.attr("disabled", false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    ErrorType.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function saveTicket() {
            $('#lblErrormsg').text('');
            var validFilesTypes = ["pdf", "jpg", "png", "docx", "jpeg", "doc", "gif"];
            var label = document.getElementById("<%=lblErrormsg.ClientID%>");
            var path = $("#fuattachment").val();
            var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
            var isValidFile = false;
            for (var i = 0; i < validFilesTypes.length; i++) {
                if (ext == validFilesTypes[i]) {
                    isValidFile = true;
                    break;
                }
            }
            if (!isValidFile) {
                $("#lblErrormsg").text("Invalid File. Please upload a File with" + validFilesTypes.join(", "));

            }
            var InsDocDet = {};
            var fullPath = $("#fuattachment").val(); //document.getElementById('doc_upload').value;
            if (fullPath) {
                var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
                var filename = fullPath.substring(startIndex);
                if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
                    filename = filename.substring(1);
                    InsDocDet.file_name = filename;
                }
            }

            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/TicketSave",
                data: '{DepartmentFrom:"' + $("#ddlDept").val() + '",Floor:"' + $("#ddlFloor option:selected").text() + '",EmpCode:"' + $("#txtEmpCode").val() + '",DepartmentTo:"' + $("#ddlDepartment").val() + '",ErrorType:"' + $("#ddlErrorType option:selected").text() + '",ErrorTypeID:"' + $("#ddlErrorType").val() + '",Summary:"' + $("#txtDescription").val() + '",Attachment:"' + $("#fuattachment").val() + '",Priority:"' + $("#ddlPriority").val() + '",NoOfPeopleEffected:"' + $("#txtNoOfPeopleEffected").val() + '",StartDate:"' + $("#txtStartDate").val() + '",StartTime:"' + $("#txtStartTime").val() + '",Extension:"' + ext + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                secureuri: false,
                fileElementId: 'fileToUpload',
                success: function (response) {
                    ticket =response.d;
                    if (ticket == "1") {                        DisplayMsg('MM01', 'lblErrormsg');
                    }
                    else if (ticket=="0") {
                        $("#lblErrormsg").text('Wrong File Extension of Selected Attachment');
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        function validate() {
            //if ($("#ddlFloor").val() == "0") {
            //    $("#lblErrormsg").text('Please Select Floor');
            //    $("#ddlFloor").focus();
            //    return false;
            //}
            if ($("#ddlDepartment").val() == "0") {
                $("#lblErrormsg").text('Please Select Department');
                $("#ddlDepartment").focus();
                return false;
            }
            if ($("#ddlErrorType").val() == "0") {
                $("#lblErrormsg").text('Please Select Error Type');
                $("#ddlErrorType").focus();
                return false;
            }
            if ($("#ddlPriority").val() == "0") {
                $("#lblErrormsg").text('Please Select Priority');
                $("#ddlPriority").focus();
                return false;
            }
            if ($("#fuattachment").val() != "") {
                var validFilesTypes = ["pdf", "jpg", "png", "docx", "jpeg", "doc", "gif"];

                var label = document.getElementById("<%=lblErrormsg.ClientID%>");
                var path = $("#fuattachment").val();
                var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
                var isValidFile = false;
                for (var i = 0; i < validFilesTypes.length; i++) {
                    if (ext == validFilesTypes[i]) {
                        isValidFile = true;
                        break;
                    }
                }
                if (!isValidFile) {
                    $("#lblErrormsg").text("Invalid File. Please upload a File with " + validFilesTypes.join(", "));
                    return false;
                }

              
                if ($("#<%=txtAttachmentName.ClientID%>").val() == "")
                {
                    $("#lblErrormsg").text('Please Enter Attachment Name');
                    return false;
                };
            }
        }

        $(document).ready(function () {
            var MaxLength = 500;
            $("#txtDescription").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#lblremaingCharacters").html(MaxLength - ($("#txtDescription").val().length));
            $("#txtDescription").bind("keyup keydown", function () {
                var chars = $("#txtDescription").val().length;
                var text = $(this).val();
                if (chars > MaxLength) {
                    $("#lblErrormsg").text("You cannot enter more than " + MaxLength + " characters.");
                    var new_text = text.substr(0, MaxLength);
                    $(this).val(new_text);
                }
                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    $(this).val($(this).val().substr(0, MaxLength));
                }
                var characterRemaining = MaxLength - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });

        });
        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }

            //List of special characters you want to restrict
            if (keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }
        function validatespace() {
            var EmpCode = $('#txtEmpCode').val();

            if (EmpCode.charAt(0) == ' ' || EmpCode.charAt(0) == '.') {
                $('#txtEmpCode').val('');
                $('#lblErrormsg').text('First Character Cannot Be Space/Dot');
                EmpCode.replace(EmpCode.charAt(0), "");
                return false;
            }

            else {
                $('#lblErrormsg').text('');
                return true;
            }
        }

        function GetAdditionalInfoID() {
            var typ = $('[id$=ddlErrorType] option:selected').text();
            $("#divDynamic").html('');

            $.ajax({
                url: 'NewTicket.aspx/GetAdditionalIdByErrorType',
                data: '{type:"' + typ + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (data) {
                var r = JSON.parse(data.d);
                var strarry = r.split(',');
                BindEmployeeErrorWis();
                var num = 1;
                for (i = 0; i < strarry.length; i++) {
                   // alert(strarry[i]);
                    
                    $.ajax({
                        url: 'NewTicket.aspx/GetAdditionalNameByID',
                        data: '{AddID:"' + strarry[i] + '"}',
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        async: false,
                        type: "POST",
                    }).done(function (res) {
                        var nm = JSON.parse(res.d);
                        var nam = nm;
                        var strlength = nm.length;
                        if (strlength > 10) {
                            nm = nm.substring(0, 11);
                        }
                        $("#divDynamic").append("<div class='col-md-3'><label class='pull-left clsoverflow' title='" + nam + "'>" + nm + "</label><b class='pull-right'>:</b></div><div class='col-md-5'><input type='text' class='clstext' Itemname='" + nam + "' id=ID_" + num + " /></div>");
                        num++;
                    });
                   
                }
                
            });
        }

        function BindEmployeeErrorWis() {
            var departmentID = $('[id$=ddlDepartment] option:selected').val();
            var typeID = $('[id$=ddlErrorType] option:selected').val();

            $.ajax({
                url: 'NewTicket.aspx/GetEmployeeErrorname',
                data: '{departID:"' + departmentID + '", typeID:"' + typeID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (data) {
                var r = JSON.parse(data.d);
               // alert(r);
                var empname = r.split('#')[1];
                var id = r.split('#')[0];
                var mobile = r.split('#')[2];
               // alert(id + " " + mobile);
                $('[id$=lblEmployeeName]').text(empname);
                $('[id$=lblEmpID]').text(id);
                $('[id$=lblEmpMobile]').text(mobile);
            });
            
        }
    </script>

    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>New Ticket </b>
            <br />
            <asp:Label ID="lblErrormsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
              New Ticket  &nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Requeting Department</label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" ClientIDMode="Static" runat="server" Enabled="false"  CssClass="requiredField" OnSelectedIndexChanged="ddlDept_SelectedIndexChanged">
                        </asp:DropDownList>
                        </div>
                        <div class="col-md-3" style="display:none;">
                            <label class="pull-left">Floor</label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5" style="display:none;">
                            <asp:DropDownList ID="ddlFloor" runat="server" ClientIDMode="Static" CssClass="requiredField">
                        </asp:DropDownList>
                        </div>
                          <div class="col-md-3" style="display:none"><label class="pull-left">Asset Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                           <asp:DropDownList ID="ddlAssetName" runat="server" ClientIDMode="Static" CssClass="requiredField">
                           </asp:DropDownList>
                        </div>
                        <div class="col-md-3"><label class="pull-left"> Department To</label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                           <asp:DropDownList ID="ddlDepartment"  ClientIDMode="Static" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddldepartment_SelectedIndexChanged1" CssClass="requiredField">
                        </asp:DropDownList>
                       </div>
                       
                       <div class="col-md-3"><label class="pull-left">Issue Type</label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                         <%--  <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                               <ContentTemplate>
                       
                                </ContentTemplate>
                           </asp:UpdatePanel>--%>
                               <asp:DropDownList ID="ddlErrorType" runat="server" ClientIDMode="Static" AutoPostBack="true"  OnSelectedIndexChanged="ddlErrorType_SelectedIndexChanged" CssClass="requiredField"><%--onchange="GetAdditionalInfoID()"--%>
                           </asp:DropDownList>
                       </div>
                        </div></div>
                <div class="col-md-1"></div></div>
            <div class="row"  style="display:none;">
                <div class="col-md-22">
                   <div class="row">
                       
                <div class="col-md-1"></div>
               
                       <div class="col-md-3"><label class="pull-left">Employee Name</label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                           <asp:Label ID="lblEmployeeName" runat="server" Font-Bold="true" Font-Size="Large" ForeColor="Red"></asp:Label>
                           <asp:Label ID="lblEmpID" runat="server" Visible="false"></asp:Label>
                        <asp:Label ID="lblEmpMobile" runat="server" Visible="false"></asp:Label>
                       </div>
                       
                       <div id="divDynamic" style="margin-top:35px;">

                       </div>
                   </div>
               </div>
                
            </div>
            <div class="row" style="display:none">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Employee Code    </label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-5">
                            <asp:TextBox ID="txtEmpCode" runat="server" onkeypress="return check(this,event)" onkeyup="validatespace();" ClientIDMode="Static" Enabled="false" MaxLength="20"></asp:TextBox>
                       </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Location</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLocation"  ClientIDMode="Static" runat="server" ></asp:TextBox>
                        </div>
                        <div class="col-md-3"><label class="pull-left">location Code</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLocationCode"  ClientIDMode="Static" runat="server" ></asp:TextBox>
                        </div>
                    </div></div></div>
            <div class="row">
                <div class="col-md-1"></div>
               <div class="col-md-22">
                   <div class="row">
                       <div class="col-md-3"><label class="pull-left">Description</label>
                           <b class="pull-right">:</b>
                       </div>
                       <div class="col-md-25">
                           <asp:TextBox ID="txtDescription" runat="server" ClientIDMode="Static" TextMode="MultiLine" Height="90px" Width="746px" CssClass="requiredField">
                        </asp:TextBox>
                        Number of Characters Left:<asp:Label runat="server" ClientIDMode="Static" ID="lblremaingCharacters" Style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </asp:Label>
                       </div>
                   </div></div></div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Attachment</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="fuattachment" runat="server" Width="250px" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Attachment Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAttachmentName" MaxLength="20" ClientIDMode="Static" runat="server" ></asp:TextBox>
                        <cc1:FilteredTextBoxExtender FilterType="UppercaseLetters,LowercaseLetters,Numbers" runat="server" ID="ftxtAttachmentName" TargetControlID="txtAttachmentName"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3"><label class="pull-left">Priority</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"><asp:DropDownList ID="ddlPriority" runat="server" ClientIDMode="Static" CssClass="requiredField">
                            </asp:DropDownList></div>
                    </div>
                </div>
            </div>
                         <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">People Effected</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtNoOfPeopleEffected" MaxLength="3" ClientIDMode="Static" runat="server" ></asp:TextBox>
                        <cc1:filteredtextboxextender id="fc1" runat="Server" targetcontrolid="txtNoOfPeopleEffected" filtertype="Numbers"></cc1:filteredtextboxextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtStartDate"  runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date" CssClass="requiredField"></asp:TextBox>
                                    <cc1:calendarextender id="ToDatecal" targetcontrolid="txtStartDate" format="dd-MMM-yyyy"
                                        animated="true" runat="server">
                                    </cc1:calendarextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtStartTime" runat="server" ClientIDMode="Static" CssClass="requiredField"/>
                        <cc1:maskededitextender id="MaskedEditExtender3" runat="server" targetcontrolid="txtStartTime" UserTimeFormat="None" mask="99:99" masktype="Time" AcceptAMPM="true"/>
                        </div>
                    </div></div></div>
        
    </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           <%-- <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <Triggers>
                    <asp:asyncpostbacktrigger controlid="btnSubmit" eventname="click"/>
                </Triggers>
                <ContentTemplate>
                    
                    
                </ContentTemplate>
            </asp:UpdatePanel>--%>
            <asp:Button ID="btnSubmit" OnClientClick="return validate();" runat="server" Text="Save" OnClick="btnSubmit_Click" CssClass="ItDoseButton" />
            <%--<input type="button" id="btnSaveAdd" value="Save Add" />--%>
            <input type="button" value="Save" class="ItDoseButton" id="btnSave" style="display: none" onclick="saveTicket()" />
        </div></div>
    <script type="text/javascript">
       

        function SaveAdditionalname(ticketNo) {
            var len = $('.clstext').length;
           // alert(len);
            for (i = 1; i <= len; i++) {
                var value = $("#ID_" + i).val();
                var nam = $("#ID_" + i).attr("Itemname");

                $.ajax({
                    url: 'NewTicket.aspx/GetAdditionalIDByName',
                    data: '{name:"' + nam + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    type: "POST",
                }).done(function (data) {
                    var r = JSON.parse(data.d);

                    $.ajax({
                        url: 'NewTicket.aspx/SaveAdditionalInfo',
                        data: '{TicketID:"' + ticketNo + '", AdditionalID:"' + r + '",AdditionalName:"' + nam + '",Content:"' + value + '"}',
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        async: false,
                        type: "POST",
                    }).done(function (res) {

                    });
                });
            }
        }
        
    </script>
</asp:Content>

