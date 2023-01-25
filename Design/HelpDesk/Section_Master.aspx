<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Section_Master.aspx.cs" Inherits="Design_HelpDesk_Section_Master" %>

<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
              <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script runat="server">
        protected string BindAdditionalInfoo()
        {
            string str = "";
            string query = "SELECT * FROM ass_additional_info WHERE IsActive=1";

            System.Data.DataTable dt = StockReports.GetDataTable(query);

            if (dt.Rows.Count > 0)
            {
                ddlAditionalInfo.DataSource = dt;
                ddlAditionalInfo.DataTextField = "NAME";
                ddlAditionalInfo.DataValueField = "InfoID";
                ddlAditionalInfo.DataBind();

                //ddlAditionalInfo.Items.Insert(0, new ListItem("Select", "0"));
            }
            else
            {
                ddlAditionalInfo.Items.Clear();
                ddlAditionalInfo.DataSource = null;
                ddlAditionalInfo.DataBind();
            }
            return str;
        } 
        
    </script>
     <script type="text/javascript">
         $(document).ready(function () {
             errorTypeSearch();
                      });

         function BindData() {
             __doPostBack('<%=btnBind.ClientID %>', 'OnClick');
            }

            function errorTypeSearch() {
                $.ajax({
                    type: "POST",
                    url: "Services/HelpDesk.asmx/sectionSearch",
                    data: '{}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        errorType = jQuery.parseJSON(response.d);
                        if (errorType != null && response.d != "") {
                            var output = $('#tb_SearchErrorType').parseTemplate(errorType);

                            $('#ErrorTypeOutput').html(output);
                            $('#ErrorTypeOutput').show();

                            var num = 1;
                            /* $.each(errorType, function (i, v) {
                                 var emp = v.EmployeeID;
                                 var match = emp.split(",");
                                 var m = "";
                                 $.each(match, function (i) {
                                     $.ajax({
                                         type:"POST",
                                         url: 'ErrorType.aspx/GetEmployeename',
                                         data: '{EmployeeID:"' + $('#ddlEmployee').val() + '"}',
                                         dataType: "json",
                                         contentType: "application/json;charset=UTF-8",
                                         async: false,
                                     }).done(function (r) {
                                         var nam = JSON.parse(r.d);
                                          m += nam + ",";
                                     });
                                 });
                                 m = m.slice(0, -1);
                                 $("#cls_" + num).text(m);
                                 num++;
                             });*/
                        }
                        else {
                            $('#ErrorTypeOutput').hide();
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }

            function GetAllAditionalInfo() {
                $.ajax({
                    url: '../HelpDesk/Services/HelpDesk.asmx/GetAllAditionalInfo',
                    data: '{}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                }).done(function (result) {
                    var InvData = (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d;

                    if (InvData.length != 0) {

                        for (var i = 0; i < InvData.length; i++) {
                            var active = parseInt(InvData[i].IsActive);
                            if (active == "1") {
                                activ = "Active";
                            }
                            else if (active == "0") {
                                activ = "In-Active";
                            }
                            var namm = '"' + InvData[i].Name + "'";
                            // alert(namm);
                            $("#tblAdditionalInfo").append("<tr><td style='width:20%;' class='clsserial'>" + InvData[i].InfoID + "</td><td id=id_" + InvData[i].Name + " style=''>" + InvData[i].Name + "</td><td class=cls_" + InvData[i].Name + " style='text-align:left;'>" + activ + "</td><td><img src='../../Images/edit.png' alt='edit' class='ImgEditInfo' onclick='EditAdditionalComment(" + InvData[i].InfoID + ")' ItemName='" + InvData[i].Name + "' style='cursor:pointer;'></td></tr>");
                        }

                    }
                });
            }

            function saveErrorType() {
                $("#btnSave").val("Submitting...").attr("disabled");

                
                if ($.trim($("#txtSection_Name").val()) == "") {
                    $("#btnSave").val("Save").removeAttr("disabled", "disabled");
                    //$("#lblErrormsg").text('Please Enter Error Type');
                    modelAlert("Please Enter Section Name");
                    $("#txtSection_Name").focus();
                    return;
                }
               
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/saveSection",
                data: '{Section_Name:"' + $.trim($("#txtSection_Name").val()) + '",Status:"' + $("#<%=rbtnStatus.ClientID%> input[type:radio]:checked").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    errorType = (response.d);
                    if (errorType != null && response.d == "1") {
                        errorTypeSearch();
                        cancelErrorType();
                        DisplayMsg('MM01', 'lblErrormsg');
                    }
                    else if (errorType != null && response.d == "2") {
                        $("#lblErrormsg").text("Error Type Already Exist");
                        $("#txtErrorType").focus();
                    }
                    else {
                        DisplayMsg('MM05', 'lblErrormsg');
                    }
                    $("#btnSave").val("Save").removeAttr("disabled");
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#btnSave").val("Save").removeAttr("disabled");
                }
            });
        }

        function errorTypeCon() {
            if ($("#btnSave").val() == "Save") {
                $("#lblErrormsg").text('');
                saveErrorType();
            }
            else {
                $("#lblErrormsg").text('');
                updateErrorType(rowID);
            }
        }
        function updateErrorType(rowID) {
            if ($.trim($("#txtSection_Name").val()) == "") {
                $("#lblErrormsg").text('Please Enter Section Name');
                $("#txtSection_Name").focus();
                return;
            }
            
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/updateSection",
                data: '{Section_Name:"' + $.trim($("#txtSection_Name").val()) + '",Status:"' + $("#<%=rbtnStatus.ClientID%> input[type:radio]:checked").val() + '",RowID:"' + rowID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    errorType = (response.d);
                    if (errorType == "1") {
                        errorTypeSearch();
                        cancelErrorType();
                        DisplayMsg('MM02', 'lblErrormsg');
                    }
                    else {
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        var rowID = "";
        function editErrorType(rowid) {
            $("#txtSection_Name").val($(rowid).closest('tr').find('#tdSection_Name').text());
            rowID = $(rowid).closest('tr').find('#tdID').text();

            if ($(rowid).closest('tr').find('#tdIsActive').text() == "Active") {
                $("#<%=rbtnStatus.ClientID%>").find('input:radio[value=1]').prop('checked', true);
            }
            else {
                $("#<%=rbtnStatus.ClientID%>").find('input:radio[value=0]').prop('checked', true);
            }
            $("#btnSave").val('Update');
            $("#btnCancel").show();


            }

        function DropDownCheck(errorid) {
            $("#<%=ddlAditionalInfo.ClientID%> input[type=checkbox]").prop("checked", false);
             //HelpDesk_Error_Type.DropDownCheck(type, roleid);
             $.ajax({
                 url: 'ErrorType.aspx/DropDownCheckBoxCheck',
                 data: '{errorid:"' + errorid + '"}',
                 dataType: "json",
                 contentType: "application/json;charset=UTF-8",
                 async: false,
                 type: "POST",
             }).done(function (data) {
                 var r = JSON.parse(data.d);
                 r = r.split(',');
                 for (var i = 0; i < r.length; i++) {

                     $("#<%=ddlAditionalInfo.ClientID%> [value=" + r[i] + "]").attr("checked", "checked");
             }
             });
     }

     function cancelErrorType() {
         $("#btnSave").val('Save');
         $("#btnCancel").hide();
         $("#txtErrorType").val('');
         $("#ddlDepartment,#ddlEmployee").prop('selectedIndex', 0);
         $("#<%=rbtnStatus.ClientID%>").find('input:radio[value=1]').prop('checked', true);
            $("#lblErrormsg").text('');
            $("#ddlDepartment").removeProp('disabled');
        }

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
            //if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
            if (keychar == "," || keychar == "<" || keychar == ">" || keychar == "(" || keychar == ")") {
                return true;
            }

            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }

        function validatespace() {
            var ErrorType = $('#txtErrorType').val();
            if (ErrorType.charAt(0) == ' ' || ErrorType.charAt(0) == '.') {
                $('#txtErrorType').val('');
                $('#lblErrormsg').text('First Character Cannot Be Space/Dot');
                ErrorType.replace(ErrorType.charAt(0), "");
                return false;
            }
            else {
                $('#lblErrormsg').text('');
                return true;
            }
        }

        function ShowModalPopupp() {
            $("#myModal").show();

            // alert(selectedvals);
        }
        function CloseModalPopup() {
            $("#myModal").hide();
        }


    </script>
    <style type="text/css">
        .requiredField1 {
            border-radius:4px;
            width:90%;
            height:22px !important;
        }
        .tblAdditionalInfo {
            height:172px;
            display:block;
            overflow:scroll;
        }
            .tblAdditionalInfo tbody {
                width:100%;
                display:inline-table;
            }
    </style>
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Section Master</b><br />
            <asp:Label ID="lblErrormsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Section Master</div>
            <div class="row">
               <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Section Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text"  class="requiredField" id="txtSection_Name" style="width: 200px" tabindex="2"  title="Enter Section Name"  />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtnStatus" runat="server" RepeatDirection="Horizontal" TabIndex="3" ToolTip="Select Status">
                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                            <asp:ListItem Value="0">InActive</asp:ListItem>
                        </asp:RadioButtonList>
                        </div>

                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Additional Info
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:DropDownCheckBoxes ID="ddlAditionalInfo" runat="server" AddJQueryReference="True" UseButtons="false" UseSelectAllNode="True" Height="23px" CssClass="requiredField requiredField1" Visible="false">
                                <Texts SelectBoxCaption="Select all" />
                            </asp:DropDownCheckBoxes>
                           <%--<asp:DropDownList runat="server" ID="ddlAditionalInfo" CssClass="requiredField">

                            </asp:DropDownList>--%>
                            <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
                                <Triggers>
                                    <Ajax:AsyncPostBackTrigger ControlID="btnBind" EventName="click" />
                                </Triggers>
                                <ContentTemplate>
                            <asp:Button ID="btnBind" runat="server" Visible="false" OnClick="btnBind_Click" />
                                    </ContentTemplate>
                             </Ajax:UpdatePanel>
                        </div>
                        <div class="col-md-3" style="display:none">
                            <input type="button" id="btnNew" tabindex="4" value="New" onclick="ShowModalPopupp()" class="ItDoseButton" title="Add New Info" />
                        </div>
                    </div>
                </div>
            </div>
            
            
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                        <input type="button" id="btnSave" tabindex="4" value="Save" class="ItDoseButton" onclick="errorTypeCon()" title="Click To Submit" />
                        <input type="button" id="btnCancel" value="Cancel" tabindex="5" class="ItDoseButton" style="display: none" onclick="cancelErrorType()" title="Click To Cancel" />
                </div>
        
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Sections</div>
                        <div id="ErrorTypeOutput" style="max-height: 600px; overflow-x: auto;"></div></div>
    </div>

    <!----------------------------Modal Popup start-------------------------------------------------->
    <div id="myModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="height:350px;width:600px;padding:4px;">
                <div class="modal-header">
                  <button type="button" class="close" aria-hidden="true" onclick="CloseModalPopup()">&times;</button>
                  <h4 class="modal-title">Add New Additional Info</h4>
                </div>
                <div class="POuter_Box_Inventory" style="width:100%;">
                    <div class="Purchaseheader">
                        Add New Additional Info
                    </div>
                    <div id="divAdditionalInfo" style="overflow-x: auto;">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-22">
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Info
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-9">
                                        <asp:TextBox ID="txtAdditionalInfo" runat="server" ClientIDMode="Static" autocomplete="off"></asp:TextBox>
                                        <input type="hidden" id="hfInfo" />
                                        <input type="hidden" id="hfInfoID" />
                                    </div>
                                    
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <label class="pull-left">
                                            Active
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-9">
                                        <asp:RadioButtonList ID="rblActiveInfo" runat="server" RepeatDirection="Horizontal" TabIndex="3" ToolTip="Select Status">
                                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                            <asp:ListItem Value="0">InActive</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center; width:100%;">
                        <input type="button" id="btnInfoSave" onclick="SaveAdditionalComment()" tabindex="4" value="Save" class="ItDoseButton" title="Click To Submit" />
                        <input type="button" id="btnUpdateInfo" value="Update" class="ItDoseButton" style="display:none;"/>
                        <input type="button" id="btnCancelUpdate" onclick="CancelUpdate()" value="Cancel" class="ItDoseButton" style="display:none;"/>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center; width:100%;height:172px;">
                    <table id="tblAdditionalInfo" style="width:100%;height:172px; display:block;overflow:scroll;">
                        <thead style="display:inline-table; width:100%;">
                        <tr class="Purchaseheader" style="text-align:center;">
                            <th style="width:20%;">
                                Sr. No.
                            </th>
                            <th style="width:48%;">
                                Info
                            </th>
                            <th>
                                Status
                            </th>
                            <th>
                                Edit
                            </th>
                        </tr>
                            </thead>
                        <tbody style='display:inline-table; width:100%;'></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!----------------------------END-------------------------------------------------->
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
	<script type="text/javascript" src="../../Scripts/jquery.slimscroll.js"></script>
	<script type="text/javascript" src="../../Scripts/chosen.jquery.min.js"></script>
    <script id="tb_SearchErrorType" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdErrorType" style="width:100%;border-collapse:collapse;">
            <tr id="Header">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:250px;">Section Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Status</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">EntryBy</th>			 
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>           
            </tr>
            <#       
                var dataLength=errorType.length;
                window.status="Total Records Found :"+ dataLength;
                var objRow; 
                var num;  
                
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = errorType[j];
                    num=<#=j+1#>;
            #>
            <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;text-align:center;"><#=j+1#>
                        
                    </td>
                    <td class="GridViewLabItemStyle" id="tdSection_Name"  style="width:250px;text-align:center" ><#=objRow.Section_Name#></td>
                    <td class="GridViewLabItemStyle" id="tdID"  style="width:250px;text-align:center;display:none;" ><#=objRow.ID#></td>
                    
                    <td class="GridViewLabItemStyle" id="tdIsActive"  style="width:90px;text-align:center" ><#=objRow.IsActive#></td>
                    <td class="GridViewLabItemStyle" id="tdEmployeeID" style="width:60px;">
                    <#=objRow.EntryBy#>
                </td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center">
                        <input type="button" value="Edit"   id="btnEdit"  class="ItDoseButton" onclick="editErrorType(this);" title="Click To Edit"/>                                                    
                    </td>                    
            </tr>            
            <#}#>     
        </table>    
    </script>

    <script type="text/javascript">

        function CancelUpdate() {
            $("#btnUpdateInfo").hide();
            $("#btnCancelUpdate").hide();
            $("#btnInfoSave").show();
            $('[id$=txtAdditionalInfo]').val('');
            $('#<%=rblActiveInfo.ClientID%>').find("input[value=1]").prop("checked", true);
        }


        // var srn = 0;
        function SaveAdditionalComment() {
            var info = $('[id$=txtAdditionalInfo]').val().trim();
            var active = $('[id$=rblActiveInfo] input:checked').val();

            if (info == "") {
                alert("Please Enter Info");
            }
            else {
                var srn = $(".clsserial").length;
                $.ajax({
                    type: "POST",
                    url: 'ErrorType.aspx/CheckIsInfoExists',
                    data: '{Inf:"' + info + '"}',
                    async: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                }).done(function (data) {
                    var Is = JSON.parse(data.d);

                    if (Is == "0") {

                        $.ajax({
                            type: "POST",
                            url: 'ErrorType.aspx/SaveAdditionalInfo',
                            data: '{AddInfo:"' + info + '",Isactive:"' + active + '"}',
                            async: false,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                        }).done(function (r) {
                            var re = JSON.parse(r.d);
                            if (re == "1") {
                                srn++;
                                var activ = "";
                                if (active == "1") {
                                    activ = "Active";
                                }
                                else {
                                    activ = "In-Active";
                                }
                                $("#tblAdditionalInfo").show();
                                $('[id$=txtAdditionalInfo]').val('');
                                $("#tblAdditionalInfo").append("<tr><td style='width:20%;' class='clsserial'>" + srn + "</td><td id=id_" + info + ">" + info + "</td><td class=cls_" + info + ">" + activ + "</td><td><img src='../../Images/edit.png' alt='edit' class='ImgEditInfo' onclick='EditAdditionalComment(" + srn + ")' ItemName='" + info + "' style='cursor:pointer;'></td></tr>");
                                // var ddl = document.getElementById("<%=ddlAditionalInfo.ClientID%>");
                                // var option = document.createElement("OPTION");
                                // option.innerHTML = info;
                                // option.value = info;
                                // document.getElementById("<%=ddlAditionalInfo.ClientID%>").options.add(option);

                                //  BindData();


                            }
                            else if (re == "0") {
                                var len = $("#tblAdditionalInfo tr").length;
                                if (len > 0) {

                                }
                                else {
                                    $("#tblAdditionalInfo").hide();
                                }
                                alert("something went wrong try again...");
                                $('[id$=txtAdditionalInfo]').val('');
                            }
                        });
                    }
                    else {
                        alert("already exists try another name...");
                        $('[id$=txtAdditionalInfo]').val('');
                        $('[id$=txtAdditionalInfo]').focus();
                    }
                });
            }
        };

        //function Add(Info) {
        //    var ddl = document.getElementById("ddlAditionalInfo");
        //    var option = document.createElement("OPTION");
        //    option.innerHTML = Info;
        //    option.value = Info;
        //    ddl.options.add(option);
        //}


        function EditAdditionalComment(n) {

            // var n = $(this).attr("ItemName");

            $.ajax({
                url: 'ErrorType.aspx/GetInfoNameById',
                data: '{InID:"' + n + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
            }).done(function (k) {
                var s = JSON.parse(k.d);
                $.ajax({
                    url: '../HelpDesk/Services/HelpDesk.asmx/GetDataByName',
                    data: '{InfoName:"' + s + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                }).done(function (result) {
                    var InvData = (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d;
                    if (InvData.length != 0) {
                        $('#<%=txtAdditionalInfo.ClientID %>').val(InvData[0].Name);
                        $("#hfInfo").val(InvData[0].Name);
                        $("#hfInfoID").val(InvData[0].InfoID);
                        var active = parseInt(InvData[0].IsActive);
                        $('#<%=rblActiveInfo.ClientID%>').find("input[value='" + active + "']").prop("checked", true);
                        $("#btnUpdateInfo").show();
                        $("#btnCancelUpdate").show();
                        $("#btnInfoSave").hide();
                    }
                    else {
                        $("#btnUpdateInfo").hide();
                        $("#btnCancelUpdate").hide();
                        $("#btnInfoSave").show();
                    }
                });
            });
        };
        $("#btnUpdateInfo").click(function () {

            var info = $('[id$=txtAdditionalInfo]').val().trim();
            var active = $('[id$=rblActiveInfo] input:checked').val();
            var hfinfo = $("#hfInfo").val();
            var infoid = $("#hfInfoID").val();
            var activ;


            $.ajax({
                type: "POST",
                url: 'ErrorType.aspx/CheckInfoName',
                data: '{Infoname:"' + info + '",Id:"' + infoid + '"}',
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
            }).done(function (data) {
                var Is = JSON.parse(data.d);

                if (Is == "0") {

                    $.ajax({
                        url: 'ErrorType.aspx/UpdateInfo',
                        data: '{Infoname:"' + info + '",Active:"' + active + '",InID:"' + infoid + '"}',
                        async: false,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        type: "POST",
                    }).done(function (r) {
                        var re = JSON.parse(r.d);

                        if (re == "1") {
                            if (active == "1") {
                                activ = "Active";
                            }
                            else if (active == "0") {
                                activ = "In-Active";
                            }
                            $("#id_" + hfinfo).text(info);
                            $(".cls_" + hfinfo).text(activ);
                        }
                        else {
                            alert("something went wrong try again...");
                        }
                    });
                }
                else {
                    alert("already exists try another name...");
                    $('[id$=txtAdditionalInfo]').val(hfinfo);

                }
            });
        });
    </script>
</asp:Content>

